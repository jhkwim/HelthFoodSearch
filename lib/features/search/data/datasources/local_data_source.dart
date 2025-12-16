import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../models/food_item_hive_model.dart';

abstract class LocalDataSource {
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items);
  Future<List<FoodItemHiveModel>> getFoodItems();
  Future<List<FoodItemHiveModel>> searchFoodByName(String query);
  Future<List<FoodItemHiveModel>> searchFoodByIngredients(List<String> ingredients, {bool matchAll = false});
  Future<void> clearData();
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl implements LocalDataSource {
  static const String boxName = 'food_items_box';

  @override
  Future<void> cacheFoodItems(List<FoodItemHiveModel> items) async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    // Use putAll for batch insert using reportNo as key if unique, or just add
    final Map<String, FoodItemHiveModel> map = {
      for (var item in items) item.reportNo: item
    };
    await box.putAll(map);
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
        .where((item) => item.prdlstNm.contains(query))
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
  Future<void> clearData() async {
    final box = await Hive.openBox<FoodItemHiveModel>(boxName);
    await box.clear();
  }
}
