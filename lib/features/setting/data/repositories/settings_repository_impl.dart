import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepositoryImpl implements ISettingsRepository {
  final Box settingsBox;

  SettingsRepositoryImpl() : settingsBox = Hive.box('settings');

  static const String apiKeyKey = 'API_KEY';
  static const String textScaleKey = 'TEXT_SCALE';

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final apiKey = settingsBox.get(apiKeyKey) as String?;
      final textScale = settingsBox.get(textScaleKey, defaultValue: 1.0) as double;
      return Right(AppSettings(apiKey: apiKey, textScale: textScale));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveApiKey(String apiKey) async {
    try {
      await settingsBox.put(apiKeyKey, apiKey);
      return Right(null);
    } catch (e, stackTrace) {
      debugPrint('Error saving API key: $e');
      debugPrint('Stack trace: $stackTrace');
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearData() async {
    try {
      await settingsBox.clear();
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTextScale(double scale) async {
    try {
      await settingsBox.put(textScaleKey, scale);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
