import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/entities/ingredient.dart';
import '../../domain/repositories/i_food_repository.dart';
import 'package:health_food_search/features/search/data/datasources/local_data_source.dart';
import 'package:health_food_search/features/search/data/datasources/remote_data_source.dart';
import '../models/food_item_hive_model.dart';
import '../models/raw_material_hive_model.dart';
import '../services/food_data_sync_service.dart';
import '../../../../core/di/injection.dart';
import '../../../setting/domain/repositories/i_settings_repository.dart';

import 'dart:async'; // Add async for Stream
import 'package:health_food_search/core/utils/ingredient_refiner.dart'; // Import Refiner

@LazySingleton(as: IFoodRepository)
class FoodRepositoryImpl implements IFoodRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;
  final FoodDataSyncService syncService;

  FoodRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.syncService,
  );

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
  Future<Either<Failure, List<FoodItem>>> searchFoodByIngredients(
    List<String> ingredients, {
    IngredientSearchType type = IngredientSearchType.include,
  }) async {
    try {
      final results = await localDataSource.searchFoodByIngredients(
        ingredients,
        type: type,
      );
      return Right(results.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> getSuggestedIngredients(
    String query,
  ) async {
    try {
      // Use dedicated ingredient search
      final ingredients = await localDataSource.searchIngredients(query);
      return Right(
        ingredients.map((e) => Ingredient(name: e)).take(20).toList(),
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncData(
    String? apiKey, {
    Function(double)? onProgress,
  }) async {
    return syncService.sync(
      apiKey: apiKey,
      onProgress: onProgress,
    );
  }

  @override
  Stream<double> refineLocalData() async* {
    try {
      final items = await localDataSource.getFoodItems();
      final total = items.length;
      if (total == 0) return;

      yield 0.1; // Loaded

      // Run refinement in Isolate to avoid blocking UI
      // Isolate communication is tricky with Stream.
      // Simplified approach: Yield progress periodically.
      // Or use compute for batches?
      // Let's use batch processing in main thread with delays to yield? No, Isolate is better.
      // But passing Stream back from Isolate is hard.
      // Better: Process entirely in compute, but we need progress updates.
      // Standard compute doesn't support progress.
      // Alternative: Use batch processing with `await Future.delayed(Duration.zero)` to yield control.
      // This is simpler and sufficient for ~30k items if batch size is small.

      int processed = 0;
      final int batchSize = 500;

      final List<FoodItemHiveModel> updatedItems = [];

      for (int i = 0; i < total; i += batchSize) {
        int end = i + batchSize;
        if (end > total) end = total;

        // Process batch
        final batch = items.sublist(i, end);
        for (var item in batch) {
          final newMain = IngredientRefiner.refineAll(item.rawmtrlNm);
          // Only update if changed? Technically refineAll might have changed logic so yes.
          // But strict equality check on list might be slow.
          // Just update everything to be safe and consistent with new rules.
          updatedItems.add(item.copyWith(mainIngredients: newMain));
        }

        // Async yield to UI every batch to prevent frame drop
        await Future.delayed(Duration.zero);

        processed += batch.length;
        // Emit progress: Phase 1 (Refining) 10% -> 70%
        yield 0.1 + (processed / total) * 0.6;
      }

      yield 0.75; // Saving...

      // Save updated items
      // Since we updated all, we overwrite all.
      // Saving 30k items might take time.
      // Split save into chunks too?
      // updateFoodItems implementation uses putAll.
      // Let's do chunked save to show progress.

      int saved = 0;
      for (int i = 0; i < total; i += batchSize) {
        int end = i + batchSize;
        if (end > total) end = total;

        final batch = updatedItems.sublist(i, end);
        await localDataSource.updateFoodItems(
          batch,
        ); // This appends/overwrites by key

        // Async yield
        await Future.delayed(Duration.zero);

        saved += batch.length;
        // Emit progress: Phase 2 (Saving) 75% -> 100%
        yield 0.75 + (saved / total) * 0.25;
      }

      yield 1.0;
    } catch (e) {
      debugPrint('Refine Error: $e');
      throw CacheFailure(e.toString());
    }
  }

  @override
  Future<Either<Failure, List<String>?>> getRawMaterials(
    String reportNo,
  ) async {
    try {
      // 1. Try Local First
      final result = await localDataSource.getRawMaterials(reportNo);
      if (result != null && result.isNotEmpty) {
        return Right(result);
      }

      // 2. Fallback: Fetch from Remote (On-Demand)
      // Retrieve API Key from Settings
      final settingsRepo = getIt<ISettingsRepository>();
      final settingsResult = await settingsRepo.getSettings();

      return await settingsResult.fold(
        (failure) => const Right(
          null,
        ), // If settings fail, just return null (no data shown)
        (settings) async {
          final apiKey = settings.apiKey;
          if (apiKey == null || apiKey.isEmpty) return const Right(null);

          try {
            final response = await remoteDataSource.fetchRawMaterialsByReportNo(
              apiKey,
              reportNo,
            );
            final rows = response.data?.row;

            if (rows != null && rows.isNotEmpty) {
              // Aggregate (though filtering by reportNo should return rows for one report)
              final Set<String> rawMaterials = {};
              for (var row in rows) {
                rawMaterials.add(row.rawMtrlNm);
              }

              // Cache it!
              final model = RawMaterialHiveModel(
                reportNo: reportNo,
                rawMtrlNms: rawMaterials.toList(),
              );
              await localDataSource.cacheRawMaterials([model]);

              return Right(rawMaterials.toList());
            }
          } catch (e) {
            debugPrint('On-Demand C003 Fetch Failed: $e');
            // Ignore remote failure and return null (graceful degradation)
          }
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDataExistence() async {
    try {
      final result = await localDataSource.hasData();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, StorageInfo>> getStorageInfo() async {
    try {
      final result = await localDataSource.getStorageInfo();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearData() async {
    try {
      await localDataSource.clearData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
