import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepositoryImpl implements ISettingsRepository {
  final FlutterSecureStorage secureStorage;

  SettingsRepositoryImpl(this.secureStorage);

  static const String apiKeyKey = 'API_KEY';

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final apiKey = await secureStorage.read(key: apiKeyKey);
      // For now, only API Key is persistent. Last sync time can be added to shared prefs or hive later.
      return Right(AppSettings(apiKey: apiKey));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveApiKey(String apiKey) async {
    try {
      await secureStorage.write(key: apiKeyKey, value: apiKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearData() async {
    try {
      await secureStorage.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
