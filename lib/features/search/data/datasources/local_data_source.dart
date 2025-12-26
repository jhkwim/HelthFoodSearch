import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:universal_io/io.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import '../../domain/entities/storage_info.dart';
import '../models/food_item_hive_model.dart';
import '../models/raw_material_hive_model.dart';

abstract class LocalDataSource {
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items);
  Future<void> updateFoodItems(List<FoodItemHiveModel> items);
  Future<void> cacheRawMaterials(List<RawMaterialHiveModel> items);
  Future<List<FoodItemHiveModel>> getFoodItems();
  Future<List<FoodItemHiveModel>> searchFoodByName(String query);
  Future<List<FoodItemHiveModel>> searchFoodByIngredients(
    List<String> ingredients, {
    IngredientSearchType type = IngredientSearchType.include,
  });
  Future<List<String>?> getRawMaterials(String reportNo);
  Future<FoodItemHiveModel?> getFoodItemByReportNo(String reportNo);
  Future<void> clearData();
  Future<bool> hasData();
  Future<StorageInfo> getStorageInfo();

  /// Searches for unique main ingredients directly.
  Future<List<String>> searchIngredients(String query);
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  static const String boxName = 'food_items_box';
  static const String rawMaterialBoxName = 'raw_materials_box_v2';

  @override
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    final Map<String, FoodItemHiveModel> map = {
      for (var item in items) item.reportNo: item,
    };
    await box.putAll(map);
  }

  @override
  Future<void> updateFoodItems(List<FoodItemHiveModel> items) async {
    // Re-use cacheFoodItems since putAll overwrites by key (reportNo)
    await cacheFoodItems(items);
  }

  @override
  Future<void> cacheRawMaterials(List<RawMaterialHiveModel> items) async {
    final box = await Hive.openBox<RawMaterialHiveModel>(rawMaterialBoxName);

    // Efficient merge strategy: Read potentially affected items?
    // Or just iterate. 1000 items is fast enough.

    for (var newItem in items) {
      final existingKey = newItem.reportNo;
      final existingItem = box.get(existingKey);

      if (existingItem != null) {
        // Create new list to ensure Hive detects change if we were inplace modifying
        // But here we are just saving a modified object or new object.
        // It's safer to create a new object or modify list and verify save.
        // Since Hive objects are mutable if extends HiveObject.
        existingItem.rawMtrlNms.addAll(newItem.rawMtrlNms);
        await box.put(existingKey, existingItem);
      } else {
        await box.put(existingKey, newItem);
      }
    }
  }

  @override
  Future<List<FoodItemHiveModel>> getFoodItems() async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.values.toList();
  }

  @override
  Future<List<FoodItemHiveModel>> searchFoodByName(String query) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.values
        .where(
          (item) =>
              item.prdlstNm.contains(query) ||
              item.reportNo.contains(query) ||
              item.lcnsNo.contains(query),
        )
        .toList();
  }

  @override
  Future<List<FoodItemHiveModel>> searchFoodByIngredients(
    List<String> ingredients, {
    IngredientSearchType type = IngredientSearchType.include,
  }) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.values.where((item) {
      if (ingredients.isEmpty) return false;

      if (type == IngredientSearchType.include) {
        // 1. Include Mode: Item must contain ALL queried ingredients.
        // (AND logic for query items)
        return ingredients.every(
          (ing) => item.mainIngredients.any((main) => main.contains(ing)),
        );
      } else {
        // 2. Exclusive Mode: Item must contain ONLY the queried ingredients.
        // Logic: Set Equality (Item == Query)
        // a) Item must contain ALL queried ingredients.
        // b) Item must NOT contain any ingredient NOT in query.

        if (item.mainIngredients.isEmpty) return false;

        // Condition A: All query ingredients must be present in item
        final bool hasAllQuery = ingredients.every(
          (ing) => item.mainIngredients.any((main) => main.contains(ing)),
        );
        if (!hasAllQuery) return false;

        // Condition B: All item ingredients must be covered by query
        final bool hasOnlyQuery = item.mainIngredients.every(
          (main) => ingredients.any((ing) => main.contains(ing)),
        );
        return hasOnlyQuery;
      }
    }).toList();
  }

  @override
  Future<List<String>?> getRawMaterials(String reportNo) async {
    final box = await Hive.openBox<RawMaterialHiveModel>(rawMaterialBoxName);
    final item = box.get(reportNo);
    return item?.rawMtrlNms;
  }

  @override
  Future<FoodItemHiveModel?> getFoodItemByReportNo(String reportNo) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.get(reportNo);
  }

  @override
  Future<void> clearData() async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    await box.clear();
    final rawBox = await Hive.openBox<RawMaterialHiveModel>(rawMaterialBoxName);
    await rawBox.clear();
  }

  @override
  Future<bool> hasData() async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.isNotEmpty;
  }

  @override
  Future<StorageInfo> getStorageInfo() async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    final count = box.length;
    int size = -1;

    try {
      if (!kIsWeb && box.path != null) {
        final file = File(box.path!);
        if (await file.exists()) {
          size = await file.length();
        }
      }
    } catch (e) {
      // Ignore errors for size calculation
    }

    return StorageInfo(count: count, sizeBytes: size);
  }

  @override
  Future<List<String>> searchIngredients(String query) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    final Set<String> matches = {};

    // Iterate all values.
    // Optimization: Stop after N matches?
    // The user wants suggestions, so 20-50 is enough.
    // But we need to be diverse.
    // Let's iterate all (30k is fast) and dedupe.

    for (var item in box.values) {
      for (var ing in item.mainIngredients) {
        if (ing.contains(query)) {
          matches.add(ing);
          if (matches.length >= 50) break; // Limit internal collection
        }
      }
      if (matches.length >= 50) break;
    }

    return matches.toList();
  }
}
