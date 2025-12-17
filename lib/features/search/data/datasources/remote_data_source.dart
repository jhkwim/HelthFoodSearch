import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/dto/food_response_dto.dart';
import '../models/dto/raw_material_response_dto.dart';

abstract class RemoteDataSource {
  Future<FoodResponseDto> fetchFoodData(String apiKey, int start, int end);
  Future<RawMaterialResponseDto> fetchRawMaterials(String apiKey, int start, int end);
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<FoodResponseDto> fetchFoodData(String apiKey, int start, int end) async {
    try {
      final response = await dio.get(
        'https://openapi.foodsafetykorea.go.kr/api/$apiKey/I0030/json/$start/$end',
      );

      if (response.statusCode == 200) {
        return FoodResponseDto.fromJson(response.data);
      } else {
        throw const ServerFailure('API Call Failed');
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<RawMaterialResponseDto> fetchRawMaterials(String apiKey, int start, int end) async {
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
}
