import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/food_item.dart';
import '../entities/ingredient.dart';

abstract class IFoodRepository {
  Future<Either<Failure, List<FoodItem>>> searchFoodByName(String query);
  
  Future<Either<Failure, List<FoodItem>>> searchFoodByIngredients(List<String> ingredients, {bool matchAll = false});
  
  Future<Either<Failure, List<Ingredient>>> getSuggestedIngredients(String query);
  
  Future<Either<Failure, void>> syncData(String apiKey, {Function(double)? onProgress});
  
  Future<Either<Failure, bool>> hasData();
}
