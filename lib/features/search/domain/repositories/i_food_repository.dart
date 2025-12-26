import 'package:dartz/dartz.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import '../../../../core/error/failures.dart';
import '../entities/food_item.dart';
import '../entities/storage_info.dart';
import '../entities/ingredient.dart';

abstract class IFoodRepository {
  Future<Either<Failure, List<FoodItem>>> searchFoodByName(String query);

  Future<Either<Failure, List<FoodItem>>> searchFoodByIngredients(
    List<String> ingredients, {
    IngredientSearchType type = IngredientSearchType.include,
  });

  Future<Either<Failure, List<Ingredient>>> getSuggestedIngredients(
    String query,
  );

  Future<Either<Failure, void>> syncData(
    String apiKey, {
    Function(double)? onProgress,
  });
  Stream<double> refineLocalData();

  Future<Either<Failure, bool>> checkDataExistence();
  Future<Either<Failure, StorageInfo>> getStorageInfo();
  Future<Either<Failure, List<String>?>> getRawMaterials(String reportNo);
  Future<Either<Failure, void>> clearData();
}
