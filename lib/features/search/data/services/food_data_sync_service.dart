import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/ingredient_refiner.dart';
import '../datasources/food_data_parser.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/food_item_hive_model.dart';
import '../../../setting/domain/repositories/i_settings_repository.dart';

@lazySingleton
class FoodDataSyncService {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final ISettingsRepository settingsRepository;

  static const String dataVersionKey = 'DATA_VERSION';

  FoodDataSyncService(
    this.remoteDataSource,
    this.localDataSource,
    this.settingsRepository,
  );

  /// 최신 데이터 동기화 실행 (1순위: CDN 다운로드, 2순위: 공공 API Fallback)
  Future<Either<Failure, void>> sync({
    String? apiKey,
    void Function(double)? onProgress,
  }) async {
    try {
      // 1순위: CDN 초고속 동기화 시도
      final cdnSuccess = await _trySyncFromCdn(onProgress);
      if (cdnSuccess) {
        return const Right(null);
      }

      // 2순위: Fallback 공공 API 호출
      if (apiKey == null || apiKey.trim().isEmpty) {
        return const Left(
          ServerFailure(
            'CDN 최신 데이터를 불러올 수 없으며, 등록된 API Key가 없어 동기화를 진행할 수 없습니다.',
          ),
        );
      }

      return await _syncFromPublicApi(apiKey, onProgress);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// GitHub Release CDN에서 압축 데이터를 받아 적재
  Future<bool> _trySyncFromCdn(void Function(double)? onProgress) async {
    try {
      final serverVersionDto = await remoteDataSource.fetchDataVersion();

      // 0.0 ~ 0.5: 압축 파일 다운로드
      final bytes = await remoteDataSource.downloadFoodDataBytes(
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final p = (received / total).clamp(0.0, 1.0) * 0.5;
            onProgress?.call(p);
          }
        },
      );

      // 백그라운드 Isolate 파싱 (성분 정제 룰 주입)
      final items = await FoodDataParser.parseGzBytes(
        bytes,
        refinementRules: IngredientRefiner.currentRemoteRules,
      );

      if (items.isEmpty) {
        return false;
      }

      // 0.5 ~ 1.0: Chunk 단위 적재 및 UI 이벤트 루프 양보
      await localDataSource.cacheFoodItemsInChunks(
        items,
        onProgress: (storeP) {
          onProgress?.call(0.5 + (storeP * 0.5));
        },
      );

      // 동기화 시간 및 데이터 버전 기록
      await settingsRepository.saveLastSyncTime(DateTime.now());
      if (serverVersionDto != null) {
        final box = Hive.box('settings');
        await box.put(dataVersionKey, serverVersionDto.version);
      }

      return true;
    } catch (e) {
      debugPrint('CDN 동기화 실패 -> Fallback으로 전환: $e');
      return false;
    }
  }

  /// 공공 API (식품안전나라 I0030) 페이징 직접 호출 Fallback
  Future<Either<Failure, void>> _syncFromPublicApi(
    String apiKey,
    void Function(double)? onProgress,
  ) async {
    final initialFood = await remoteDataSource.fetchFoodData(apiKey, 1, 1);
    if (initialFood.data == null) {
      return const Left(ServerFailure('API 응답에 데이터가 없습니다. (I0030 Missing)'));
    }

    final totalCount = int.tryParse(initialFood.data!.totalCount) ?? 0;
    if (totalCount == 0) return const Right(null);

    await localDataSource.clearData();

    const int batchSize = 1000;
    for (int i = 1; i <= totalCount; i += batchSize) {
      final int end =
          (i + batchSize - 1 > totalCount) ? totalCount : i + batchSize - 1;
      final response = await remoteDataSource.fetchFoodData(apiKey, i, end);
      final rows = response.data?.row;

      if (rows != null && rows.isNotEmpty) {
        final batch = rows.map((dto) {
          return FoodItemHiveModel.fromEntity(dto.toEntity());
        }).toList();
        await localDataSource.cacheFoodItems(batch);
      }

      onProgress?.call(end / totalCount);
    }

    await settingsRepository.saveLastSyncTime(DateTime.now());
    return const Right(null);
  }
}
