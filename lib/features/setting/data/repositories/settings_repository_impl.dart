import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart'; // Add this for ThemeMode
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
  static const String lastSyncTimeKey = 'LAST_SYNC_TIME';
  static const String updateIntervalKey = 'UPDATE_INTERVAL';
  static const String themeModeKey = 'THEME_MODE'; // New key
  static const String refinementRulesKey = 'REFINEMENT_RULES';
  static const String refinementRulesUpdatedKey = 'REFINEMENT_RULES_UPDATED_AT';

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final apiKey = settingsBox.get(apiKeyKey) as String?;
      final textScale =
          settingsBox.get(textScaleKey, defaultValue: 1.0) as double;
      final updateInterval =
          settingsBox.get(updateIntervalKey, defaultValue: 30) as int;

      ThemeMode themeMode = ThemeMode.system;
      final themeIndex = settingsBox.get(themeModeKey) as int?;
      if (themeIndex != null &&
          themeIndex >= 0 &&
          themeIndex < ThemeMode.values.length) {
        themeMode = ThemeMode.values[themeIndex];
      }

      DateTime? lastSyncTime;
      final lastSyncStr = settingsBox.get(lastSyncTimeKey) as String?;
      if (lastSyncStr != null) {
        lastSyncTime = DateTime.tryParse(lastSyncStr);
      }

      DateTime? lastRefinementUpdate;
      final lastRefinementStr =
          settingsBox.get(refinementRulesUpdatedKey) as String?;
      if (lastRefinementStr != null) {
        lastRefinementUpdate = DateTime.tryParse(lastRefinementStr);
      }

      return Right(
        AppSettings(
          apiKey: apiKey,
          textScale: textScale,
          lastSyncTime: lastSyncTime,
          updateIntervalDays: updateInterval,
          themeMode: themeMode,
          lastRefinementUpdate: lastRefinementUpdate,
        ),
      );
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

  @override
  Future<Either<Failure, void>> saveLastSyncTime(DateTime time) async {
    try {
      await settingsBox.put(lastSyncTimeKey, time.toIso8601String());
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUpdateInterval(int days) async {
    try {
      await settingsBox.put(updateIntervalKey, days);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveThemeMode(ThemeMode mode) async {
    try {
      await settingsBox.put(themeModeKey, mode.index);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getRefinementRules() async {
    try {
      final rules = settingsBox.get(refinementRulesKey);
      if (rules != null && rules is Map) {
        return Right(Map<String, String>.from(rules));
      }
      return const Right({});
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveRefinementRules(
    Map<String, String> rules,
  ) async {
    try {
      await settingsBox.put(refinementRulesKey, rules);
      await settingsBox.put(
        refinementRulesUpdatedKey,
        DateTime.now().toIso8601String(),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DateTime?>> getLastRefinementUpdateTime() async {
    try {
      final str = settingsBox.get(refinementRulesUpdatedKey) as String?;
      if (str != null) {
        return Right(DateTime.tryParse(str));
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
