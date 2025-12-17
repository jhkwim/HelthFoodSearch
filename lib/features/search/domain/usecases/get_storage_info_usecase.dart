import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/storage_info.dart';
import '../repositories/i_food_repository.dart';

@lazySingleton
class GetStorageInfoUseCase implements UseCase<StorageInfo, NoParams> {
  final IFoodRepository repository;

  GetStorageInfoUseCase(this.repository);

  @override
  Future<Either<Failure, StorageInfo>> call(NoParams params) {
    return repository.getStorageInfo();
  }
}
