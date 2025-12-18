import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/export_food_data_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_api_key_usecase.dart';
import '../../domain/usecases/save_text_scale_usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveApiKeyUseCase saveApiKeyUseCase;
  final SaveTextScaleUseCase saveTextScaleUseCase;
  final ExportFoodDataUseCase exportFoodDataUseCase;

  SettingsCubit(
    this.getSettingsUseCase,
    this.saveApiKeyUseCase,
    this.saveTextScaleUseCase,
    this.exportFoodDataUseCase,
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
    // Show loading? or maybe a snackbar effect.
    // For now, let's keep the current state but maybe trigger a one-off event.
    // Since this is a simple app, let's re-emit the current state but with a flag or just do it.
    // Ideally we should have a separate state for 'Exporting' or 'ExportSuccess',
    // but to fit in the current simple structure, we can just run it.
    // If we emit SettingsLoading, the UI might flicker.
    // Let's assume the UI shows a dialog or toast on completion.
    // But we need to handle errors.

    try {
      await exportFoodDataUseCase();
      // On success, we could emit a specific state or just return.
      // Since this is a side-effect, maybe a UI event stream is better, but Cubit is state-based.
      // Let's emit a transient "ExportSuccess" state if possible, or just stay in Loaded.
      // For simplicity in this interaction:
      // We will assume the Service/UseCase handles the share sheet, so UI just needs to invoke.
      // Error handling is important though.
    } catch (e) {
      emit(SettingsError('데이터 내보내기 실패: $e')); 
      // After error, we might want to reload settings or restore state.
      // checkSettings(); // Recover
    }
  }
}

