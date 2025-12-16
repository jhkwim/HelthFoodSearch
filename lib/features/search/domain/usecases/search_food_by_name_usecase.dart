import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/food_item.dart';
import '../repositories/i_food_repository.dart';

@injectable
class SearchFoodByNameUseCase implements UseCase<List<FoodItem>, String> {
  final IFoodRepository repository;

  SearchFoodByNameUseCase(this.repository);

  @override
  Future<Either<Failure, List<FoodItem>>> call(String query) {
    return repository.searchFoodByName(query);
  }
}
