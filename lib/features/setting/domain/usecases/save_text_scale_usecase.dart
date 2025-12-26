import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class SaveTextScaleUseCase implements UseCase<void, double> {
  final ISettingsRepository repository;

  SaveTextScaleUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(double params) async {
    return repository.saveTextScale(params);
  }
}
