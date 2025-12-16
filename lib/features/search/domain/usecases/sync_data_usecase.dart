import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_food_repository.dart';

class SyncDataParams {
  final String apiKey;
  final Function(double)? onProgress;

  SyncDataParams({required this.apiKey, this.onProgress});
}

@injectable
class SyncDataUseCase implements UseCase<void, SyncDataParams> {
  final IFoodRepository repository;

  SyncDataUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SyncDataParams params) {
    return repository.syncData(params.apiKey, onProgress: params.onProgress);
  }
}
