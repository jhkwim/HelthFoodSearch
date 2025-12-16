import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/repositories/i_food_repository.dart';
import 'package:health_food_search/features/search/data/datasources/local_data_source.dart';
import 'package:health_food_search/features/search/data/datasources/remote_data_source.dart';
import '../models/food_item_hive_model.dart';

@LazySingleton(as: IFoodRepository)
class FoodRepositoryImpl implements IFoodRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  FoodRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, List<FoodItem>>> searchFoodByName(String query) async {
    try {
      final results = await localDataSource.searchFoodByName(query);
      return Right(results.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FoodItem>>> searchFoodByIngredients(List<String> ingredients, {bool matchAll = false}) async {
    try {
      final results = await localDataSource.searchFoodByIngredients(ingredients, matchAll: matchAll);
      return Right(results.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getSuggestedIngredients(String query) async {
    try {
      final foods = await localDataSource.searchFoodByName(query);
      
      final Set<String> ingredients = {};
      for (var food in foods) {
        for (var ing in food.mainIngredients) {
          if (ing.contains(query)) {
            ingredients.add(ing);
          }
        }
      }
      
      return Right(ingredients.map((e) => Ingredient(name: e)).take(20).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncData(String apiKey, {Function(double)? onProgress}) async {
    try {
      final initial = await remoteDataSource.fetchFoodData(apiKey, 1, 1);
      final totalCountStr = initial.data?.totalCount ?? '0';
      int totalCount = int.tryParse(totalCountStr) ?? 0;

      if (totalCount == 0) return Right(null);

      // Clear existing data before starting full sync
      await localDataSource.clearData();

      int batchSize = 1000;
      int fetched = 0;
      
      for (int i = 1; i <= totalCount; i += batchSize) {
        int end = i + batchSize - 1;
        if (end > totalCount) end = totalCount;
        
        final response = await remoteDataSource.fetchFoodData(apiKey, i, end);
        final rows = response.data?.row;
        
        if (rows != null) {
          final batch = rows.map((dto) {
              final entity = dto.toEntity();
              return FoodItemHiveModel.fromEntity(entity);
          }).toList();
          
          if (batch.isNotEmpty) {
             await localDataSource.cacheFoodItems(batch);
          }
        }
        
        fetched = end;
        if (onProgress != null) {
          onProgress(fetched / totalCount);
        }
      }
      
      return const Right(null);

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasData() async {
    try {
      final result = await localDataSource.hasData();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
