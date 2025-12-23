import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@lazySingleton
class ForceExpireSyncTimeUseCase implements UseCase<void, NoParams> {
  final ISettingsRepository repository;

  ForceExpireSyncTimeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    // Set last sync time to 31 days ago (just enough to trigger default 30 days)
    final oldDate = DateTime.now().subtract(const Duration(days: 31));
    return await repository.saveLastSyncTime(oldDate);
  }
}
