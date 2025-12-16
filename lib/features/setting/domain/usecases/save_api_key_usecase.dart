import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/i_settings_repository.dart';

@injectable
class SaveApiKeyUseCase implements UseCase<void, String> {
  final ISettingsRepository repository;

  SaveApiKeyUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String apiKey) {
    return repository.saveApiKey(apiKey);
  }
}
