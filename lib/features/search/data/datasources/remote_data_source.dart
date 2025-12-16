import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/dto/food_response_dto.dart';

abstract class RemoteDataSource {
  Future<FoodResponseDto> fetchFoodData(String apiKey, int start, int end);
}

@LazySingleton(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio dio;

  RemoteDataSourceImpl(this.dio);

  @override
  Future<FoodResponseDto> fetchFoodData(String apiKey, int start, int end) async {
    try {
      final response = await dio.get(
        'http://openapi.foodsafetykorea.go.kr/api/$apiKey/I0030/json/$start/$end',
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
}
