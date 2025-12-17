import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import '../entities/food_item.dart';
import '../repositories/i_food_repository.dart';

@lazySingleton
class SearchFoodByIngredientsUseCase implements UseCase<List<FoodItem>, SearchFoodByIngredientsParams> {
  final IFoodRepository repository;

  SearchFoodByIngredientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FoodItem>>> call(SearchFoodByIngredientsParams params) async {
    return await repository.searchFoodByIngredients(
      params.ingredients,
      type: params.type,
    );
  }
}

class SearchFoodByIngredientsParams extends Equatable {
  final List<String> ingredients;
  final IngredientSearchType type;

  const SearchFoodByIngredientsParams({
    required this.ingredients,
    this.type = IngredientSearchType.include,
  });

  @override
  List<Object> get props => [ingredients, type];
}
