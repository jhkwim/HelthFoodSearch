import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/export_food_data_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_api_key_usecase.dart';
import '../../domain/usecases/save_text_scale_usecase.dart';
import 'package:health_food_search/features/search/domain/usecases/refine_local_data_usecase.dart';

import '../../domain/usecases/save_update_interval_usecase.dart';
import '../../domain/usecases/force_expire_sync_time_usecase.dart';
import '../../domain/usecases/save_theme_mode_usecase.dart'; // New
import 'package:flutter/material.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveApiKeyUseCase saveApiKeyUseCase;
  final SaveTextScaleUseCase saveTextScaleUseCase;
  final ExportFoodDataUseCase exportFoodDataUseCase;
  final RefineLocalDataUseCase refineLocalDataUseCase;
  final SaveUpdateIntervalUseCase saveUpdateIntervalUseCase;
  final ForceExpireSyncTimeUseCase forceExpireSyncTimeUseCase;
  final SaveThemeModeUseCase saveThemeModeUseCase; // New

  SettingsCubit(
    this.getSettingsUseCase,
    this.saveApiKeyUseCase,
    this.saveTextScaleUseCase,
    this.exportFoodDataUseCase,
    this.refineLocalDataUseCase,
    this.saveUpdateIntervalUseCase,
    this.forceExpireSyncTimeUseCase,
    this.saveThemeModeUseCase, // New
  ) : super(SettingsInitial());

  Future<void> checkSettings() async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase(NoParams());
    
    String version = '';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
    } catch (e) {
      debugPrint('Error getting package info: $e');
    }

    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) {
        // Emit loaded with version info
        emit(SettingsLoaded(
          settings, 
          isApiKeyMissing: settings.apiKey == null || settings.apiKey!.isEmpty,
          appVersion: version,
        ));
      },
    );
  }

  Future<void> saveApiKey(String apiKey) async {
    emit(SettingsLoading());
    final result = await saveApiKeyUseCase(apiKey);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => checkSettings(),
    );
  }

  Future<void> toggleLargeText(bool enabled) async {
    final scale = enabled ? 1.3 : 1.0;
    // Optimistic update or reload? Reloading is safer for now.
    emit(SettingsLoading());
    final result = await saveTextScaleUseCase(scale);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => checkSettings(),
    );
  }

  Future<void> exportData() async {
    // ... (existing export logic) ...
    try {
      await exportFoodDataUseCase();
    } catch (e) {
      emit(SettingsError('데이터 내보내기 실패: $e')); 
    }
  }

  Future<void> refineData() async {
    final currentState = state;
    if (currentState is! SettingsLoaded) return;

    // Start
    emit(SettingsLoaded(
      currentState.settings,
      isApiKeyMissing: currentState.isApiKeyMissing,
      appVersion: currentState.appVersion,
      refinementProgress: 0.0,
    ));

    try {
      await for (final progress in refineLocalDataUseCase()) {
        emit(SettingsLoaded(
          currentState.settings,
          isApiKeyMissing: currentState.isApiKeyMissing,
          appVersion: currentState.appVersion,
          refinementProgress: progress,
        ));
      }

      // Finish (back to null progress)
      emit(SettingsLoaded(
        currentState.settings,
        isApiKeyMissing: currentState.isApiKeyMissing,
        appVersion: currentState.appVersion,
        refinementProgress: null,
      ));
      
      // Optionally show success message via side effect or snackbar managed by UI listener?
      // For now, returning to idle state implies completion.
    } catch (e) {
    } catch (e) {
      emit(SettingsError('데이터 재정제 실패: $e'));
    }
  }

  Future<void> saveUpdateInterval(int days) async {
    emit(SettingsLoading());
    final result = await saveUpdateIntervalUseCase(days);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => checkSettings(),
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    // Optimistic update for UI responsiveness??
    // Actually no, reloading settings is safer structure.
    emit(SettingsLoading());
    final result = await saveThemeModeUseCase(mode);
    await result.fold(
      (failure) async => emit(SettingsError(failure.message)),
      (_) async => await checkSettings(),
    );
  }

  Future<void> forceExpireSyncTime() async {
    emit(SettingsLoading());
    final result = await forceExpireSyncTimeUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => checkSettings(),
    );
  }
}

