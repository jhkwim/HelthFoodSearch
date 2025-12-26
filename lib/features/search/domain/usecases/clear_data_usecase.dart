import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_food_repository.dart';

@lazySingleton
class ClearDataUseCase implements UseCase<void, NoParams> {
  final IFoodRepository repository;

  ClearDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearData();
  }
}
