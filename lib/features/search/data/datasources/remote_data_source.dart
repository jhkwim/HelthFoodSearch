import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/dto/data_version_dto.dart';
import '../models/dto/food_response_dto.dart';
import '../models/dto/raw_material_response_dto.dart';

abstract class RemoteDataSource {
  Future<DataVersionDto?> fetchDataVersion();
  Future<Uint8List> downloadFoodDataBytes({
    void Function(int received, int total)? onReceiveProgress,
  });
  Future<FoodResponseDto> fetchFoodData(String apiKey, int start, int end);
  Future<RawMaterialResponseDto> fetchRawMaterials(
    String apiKey,
    int start,
    int end,
  );
  Future<RawMaterialResponseDto> fetchRawMaterialsByReportNo(
    String apiKey,
    String reportNo,
  );
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  // 1순위: GitHub Pages CDN (302 리다이렉트 없이 CORS 완전 지원)
  static const String _pagesBaseUrl =
      'https://jhkwim.github.io/HelthFoodSearch/data';

  // 2순위: GitHub Releases CDN
  static const String _releaseBaseUrl =
      'https://github.com/jhkwim/HelthFoodSearch/releases/download/data-latest';

  RemoteDataSourceImpl(this.dio);

  @override
  Future<DataVersionDto?> fetchDataVersion() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final urls = [
      '$_pagesBaseUrl/version.json?t=$timestamp',
      '$_releaseBaseUrl/version.json?t=$timestamp',
    ];

    for (final url in urls) {
      try {
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.json),
        );
        if (response.statusCode == 200 && response.data != null) {
          final dynamic data = response.data;
          if (data is Map<String, dynamic>) {
            return DataVersionDto.fromJson(data);
          }
        }
      } catch (_) {
        // 다음 URL로 시도
      }
    }
    return null;
  }

  @override
  Future<Uint8List> downloadFoodDataBytes({
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    final urls = [
      '$_pagesBaseUrl/foods_latest.json.gz',
      '$_releaseBaseUrl/foods_latest.json.gz',
    ];

    for (final url in urls) {
      try {
        final response = await dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: onReceiveProgress,
        );

        if (response.statusCode == 200 && response.data != null) {
          return Uint8List.fromList(response.data!);
        }
      } catch (_) {
        // 다음 URL로 시도
      }
    }

    throw const ServerFailure('최신 공공데이터 다운로드에 실패했습니다. 네트워크 연결을 확인해주세요.');
  }

  @override
  Future<FoodResponseDto> fetchFoodData(
    String apiKey,
    int start,
    int end,
  ) async {
    try {
      final response = await dio.get(
        'https://openapi.foodsafetykorea.go.kr/api/$apiKey/I0030/json/$start/$end',
      );

      if (response.statusCode != 200 || response.data == null) {
        throw const ServerFailure('식품안전나라 API 통신 실패');
      }

      final resData = response.data;
      if (resData is Map<String, dynamic>) {
        final rootResult = resData['RESULT'];
        final i0030Result = resData['I0030']?['RESULT'];
        final code = (rootResult?['CODE'] ?? i0030Result?['CODE']) as String?;
        final msg = (rootResult?['MSG'] ?? i0030Result?['MSG']) as String?;

        if (code != null && code != 'INFO-000') {
          throw ServerFailure('[$code] ${msg ?? "식품안전나라 서비스 오류"}');
        }
      }

      return FoodResponseDto.fromJson(response.data);
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<RawMaterialResponseDto> fetchRawMaterials(
    String apiKey,
    int start,
    int end,
  ) async {
    try {
      final response = await dio.get(
        'https://openapi.foodsafetykorea.go.kr/api/$apiKey/C003/json/$start/$end',
      );

      if (response.statusCode == 200) {
        return RawMaterialResponseDto.fromJson(response.data);
      } else {
        throw const ServerFailure('API Call Failed');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<RawMaterialResponseDto> fetchRawMaterialsByReportNo(
    String apiKey,
    String reportNo,
  ) async {
    try {
      final response = await dio.get(
        'https://openapi.foodsafetykorea.go.kr/api/$apiKey/C003/json/1/100/PRDLST_REPORT_NO=$reportNo',
      );

      if (response.statusCode == 200) {
        return RawMaterialResponseDto.fromJson(response.data);
      } else {
        throw const ServerFailure('API Call Failed');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
