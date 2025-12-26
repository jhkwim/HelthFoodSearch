import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class SaveLastSyncTimeUseCase implements UseCase<void, DateTime> {
  final ISettingsRepository repository;

  SaveLastSyncTimeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DateTime time) async {
    return repository.saveLastSyncTime(time);
  }
}
