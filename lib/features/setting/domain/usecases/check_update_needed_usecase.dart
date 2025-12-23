import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class CheckUpdateNeededUseCase implements UseCase<bool, NoParams> {
  final ISettingsRepository repository;

  // Let's set the threshold to 30 days
  static const int updateThresholdDays = 30;

  CheckUpdateNeededUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final result = await repository.getSettings();
    return result.fold(
      (failure) => Left(failure),
      (settings) {
        final lastSync = settings.lastSyncTime;
        if (lastSync == null) {
          // If never synced? Wait, if never synced, hasData should be false.
          // But if hasData is true but lastSync is null (legacy data), 
          // we should probably suggest update.
          return const Right(true);
        }

        final difference = DateTime.now().difference(lastSync);
        if (difference.inDays >= settings.updateIntervalDays) {
          return const Right(true);
        }
        return const Right(false);
      },
    );
  }
}
