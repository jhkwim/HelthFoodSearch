import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/food_item_hive_model.dart';
import '../models/raw_material_hive_model.dart';

abstract class LocalDataSource {
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items);
  Future<void> cacheRawMaterials(List<RawMaterialHiveModel> items);
  Future<List<FoodItemHiveModel>> getFoodItems();
  Future<List<FoodItemHiveModel>> searchFoodByName(String query);
  Future<List<FoodItemHiveModel>> searchFoodByIngredients(List<String> ingredients, {bool matchAll = false});
  Future<List<String>?> getRawMaterials(String reportNo);
  Future<void> clearData();
  Future<bool> hasData();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  static const String boxName = 'food_items_box';
  static const String rawMaterialBoxName = 'raw_materials_box_v2';

  @override
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    final Map<String, FoodItemHiveModel> map = {
      for (var item in items) item.reportNo: item
    };
    await box.putAll(map);
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
        .where((item) => 
          item.prdlstNm.contains(query) ||
          item.reportNo.contains(query) ||
          item.lcnsNo.contains(query)
        )
        .toList();
  }

  @override
  Future<List<FoodItemHiveModel>> searchFoodByIngredients(List<String> ingredients, {bool matchAll = false}) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    return box.values.where((item) {
      if (matchAll) {
        return ingredients.every((ing) => item.mainIngredients.any((main) => main.contains(ing)));
      } else {
        return ingredients.any((ing) => item.mainIngredients.any((main) => main.contains(ing)));
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
}
