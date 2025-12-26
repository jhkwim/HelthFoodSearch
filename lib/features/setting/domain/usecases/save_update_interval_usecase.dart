import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class SaveUpdateIntervalUseCase implements UseCase<void, int> {
  final ISettingsRepository repository;

  SaveUpdateIntervalUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int days) async {
    return repository.saveUpdateInterval(days);
  }
}
