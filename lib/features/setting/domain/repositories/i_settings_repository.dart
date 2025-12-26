import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';

abstract class ISettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();

  Future<Either<Failure, void>> saveApiKey(String apiKey);

  Future<Either<Failure, void>> clearData();

  Future<Either<Failure, void>> saveTextScale(double scale);

  Future<Either<Failure, void>> saveLastSyncTime(DateTime time);

  Future<Either<Failure, void>> saveUpdateInterval(int days);

  Future<Either<Failure, void>> saveThemeMode(ThemeMode mode); // New

  Future<Either<Failure, Map<String, String>>> getRefinementRules();
  Future<Either<Failure, void>> saveRefinementRules(Map<String, String> rules);
  Future<Either<Failure, DateTime?>> getLastRefinementUpdateTime();
}
