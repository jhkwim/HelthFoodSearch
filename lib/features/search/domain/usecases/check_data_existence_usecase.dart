import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_food_repository.dart';

@injectable
class CheckDataExistenceUseCase implements UseCase<bool, NoParams> {
  final IFoodRepository repository;

  CheckDataExistenceUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.hasData();
  }
}
