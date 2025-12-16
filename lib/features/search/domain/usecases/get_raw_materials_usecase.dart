import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_food_repository.dart';

@lazySingleton
class GetRawMaterialsUseCase implements UseCase<List<String>?, String> {
  final IFoodRepository repository;

  GetRawMaterialsUseCase(this.repository);

  @override
  Future<Either<Failure, List<String>?>> call(String reportNo) async {
    return await repository.getRawMaterials(reportNo);
  }
}
