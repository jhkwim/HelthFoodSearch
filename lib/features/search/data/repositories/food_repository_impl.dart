import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/repositories/i_food_repository.dart';
import 'package:health_food_search/features/search/data/datasources/local_data_source.dart';
import 'package:health_food_search/features/search/data/datasources/remote_data_source.dart';
import '../models/food_item_hive_model.dart';
import '../models/raw_material_hive_model.dart';

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
      // --- Phase 1: Food Data (I0030) ---
      final initialFood = await remoteDataSource.fetchFoodData(apiKey, 1, 1);
      final foodTotalConfig = initialFood.data?.totalCount ?? '0';
      int foodTotalCount = int.tryParse(foodTotalConfig) ?? 0;

      if (foodTotalCount == 0) return const Right(null);

      // Clear existing data before starting full sync
      await localDataSource.clearData();

      int batchSize = 1000;
      int foodFetched = 0;
      
      for (int i = 1; i <= foodTotalCount; i += batchSize) {
        int end = i + batchSize - 1;
        if (end > foodTotalCount) end = foodTotalCount;
        
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
        
        foodFetched = end;
        if (onProgress != null) {
          // Map 0 -> 1 to 0.0 -> 0.5
          final phase1Progress = (foodFetched / foodTotalCount) * 0.5;
          debugPrint('Phase 1 Progress: $phase1Progress');
          onProgress(phase1Progress);
        }
      }

      // --- Phase 2: Raw Material Data (C003) ---
      try {
        final initialRaw = await remoteDataSource.fetchRawMaterials(apiKey, 1, 1);
        final rawTotalConfig = initialRaw.data?.totalCount ?? '0';
        int rawTotalCount = int.tryParse(rawTotalConfig) ?? 0;
        
        if (rawTotalCount > 0) {
          int rawFetched = 0;
          for (int i = 1; i <= rawTotalCount; i += batchSize) {
            int end = i + batchSize - 1;
            if (end > rawTotalCount) end = rawTotalCount;
            
            final response = await remoteDataSource.fetchRawMaterials(apiKey, i, end);
            final rows = response.data?.row;
            
            if (rows != null) {
              final Map<String, List<String>> aggregated = {};
              for (var dto in rows) {
                if (!aggregated.containsKey(dto.reportNo)) {
                  aggregated[dto.reportNo] = [];
                }
                aggregated[dto.reportNo]!.add(dto.rawMtrlNm);
              }

              final batch = aggregated.entries.map((e) {
                return RawMaterialHiveModel(
                  reportNo: e.key, 
                  rawMtrlNms: e.value
                );
              }).toList();
              
              if (batch.isNotEmpty) {
                await localDataSource.cacheRawMaterials(batch);
              }
            }
            
            rawFetched = end;
             if (onProgress != null) {
              // Map 0 -> 1 to 0.5 -> 1.0
              final phase2Progress = 0.5 + (rawFetched / rawTotalCount) * 0.5;
              debugPrint('Phase 2 Progress: $phase2Progress');
              onProgress(phase2Progress);
            }
          }
        }
      } catch (e) {
        // If Phase 2 fails, we still consider the sync partially successful?
        // Or fail entirely? User asked to "save all data".
        // Use debug print and maybe continue? 
        // Best to throw error or log. For now, log and rethrow to alert user.
        debugPrint('Phase 2 Failed: $e');
        throw ServerFailure('Raw Material Sync Failed: $e');
      }
      
      return const Right(null);

    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>?>> getRawMaterials(String reportNo) async {
    try {
      final result = await localDataSource.getRawMaterials(reportNo);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
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
