import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/food_item.dart';
import '../repositories/i_food_repository.dart';

class SearchFoodByIngredientsParams {
  final List<String> ingredients;
  final bool matchAll;

  SearchFoodByIngredientsParams({required this.ingredients, required this.matchAll});
}

@injectable
class SearchFoodByIngredientsUseCase implements UseCase<List<FoodItem>, SearchFoodByIngredientsParams> {
  final IFoodRepository repository;

  SearchFoodByIngredientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FoodItem>>> call(SearchFoodByIngredientsParams params) {
    return repository.searchFoodByIngredients(params.ingredients, matchAll: params.matchAll);
  }
}
