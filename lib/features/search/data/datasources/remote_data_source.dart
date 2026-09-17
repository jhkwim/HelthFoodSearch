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

  // GitHub Release CDN Base URL
  static const String _releaseBaseUrl =
      'https://github.com/jhkwim/HelthFoodSearch/releases/download/data-latest';

  RemoteDataSourceImpl(this.dio);

  @override
  Future<DataVersionDto?> fetchDataVersion() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '$_releaseBaseUrl/version.json?t=$timestamp';
      final response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Cache-Control': 'no-cache'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final dynamic data = response.data;
        if (data is Map<String, dynamic>) {
          return DataVersionDto.fromJson(data);
        }
      }
      return null;
    } catch (_) {
      // Release Asset이 아직 없거나 네트워크 오류 시 null 반환 (Fallback 전환용)
      return null;
    }
  }

  @override
  Future<Uint8List> downloadFoodDataBytes({
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      final url = '$_releaseBaseUrl/foods_latest.json.gz';
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      } else {
        throw const ServerFailure('최신 데이터 다운로드에 실패했습니다.');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
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
