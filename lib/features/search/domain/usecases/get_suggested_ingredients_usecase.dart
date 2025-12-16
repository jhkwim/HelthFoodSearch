import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ingredient.dart';
import '../repositories/i_food_repository.dart';

@injectable
class GetSuggestedIngredientsUseCase implements UseCase<List<Ingredient>, String> {
  final IFoodRepository repository;

  GetSuggestedIngredientsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Ingredient>>> call(String query) {
    return repository.getSuggestedIngredients(query);
  }
}
