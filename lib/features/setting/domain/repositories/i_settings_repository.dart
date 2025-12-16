import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  
  Future<Either<Failure, void>> saveApiKey(String apiKey);
  
  Future<Either<Failure, void>> clearData();
}
