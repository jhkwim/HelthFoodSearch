import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/repositories/i_food_repository.dart';
import 'datasources/local_data_source.dart';
import 'datasources/remote_data_source.dart';
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
    // This is a simplified implementation. Real implementation would aggregate ingredients from DB.
    // For now, it returns derived ingredients from food items that match the query.
    try {
      // 1. Get all food items (or optimize to search distinct ingredients)
      // Since Hive doesn't support distinct query easily, we fetch all or search by string
      // A proper way would be to have a separate box for tokens/ingredients.
      // For this MVP, let's search food items by string and extract ingredients
      
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
      // 1. First fetch count to know how many to fetch
      // API 1..1 call
      final initial = await remoteDataSource.fetchFoodData(apiKey, 1, 1);
      final totalCountStr = initial.data?.totalCount ?? '0';
      int totalCount = int.tryParse(totalCountStr) ?? 0;

      if (totalCount == 0) return const Right(null);

      // 2. Clear old data? Or Update? Requirement says "clean/redownload" in Settings. 
      // Sync might act as 'Update' or 'Full Download'. Let's assume Full Download for now as per requirement 2.1
      // If we want incremental, we need logic. Given 2.2 loading bar, it implies a process.
      
      // We will loop. Max 1000 per request usually for public data.
      int batchSize = 1000;
      int fetched = 0;
      
      List<FoodItemHiveModel> batch = [];
      
      for (int i = 1; i <= totalCount; i += batchSize) {
        int end = i + batchSize - 1;
        if (end > totalCount) end = totalCount;
        
        final response = await remoteDataSource.fetchFoodData(apiKey, i, end);
        final rows = response.data?.row;
        
        if (rows != null) {
          batch.addAll(rows.map((dto) {
              final entity = dto.toEntity();
              return FoodItemHiveModel.fromEntity(entity);
          }).toList());
        }
        
        fetched = end;
        if (onProgress != null) {
          onProgress(fetched / totalCount);
        }
      }

      await localDataSource.cacheFoodItems(batch);
      return const Right(null);

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
