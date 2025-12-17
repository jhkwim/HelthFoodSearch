import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:health_food_search/core/usecases/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_api_key_usecase.dart';
import '../../domain/usecases/save_text_scale_usecase.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveApiKeyUseCase saveApiKeyUseCase;
  final SaveTextScaleUseCase saveTextScaleUseCase;

  SettingsCubit(
    this.getSettingsUseCase,
    this.saveApiKeyUseCase,
    this.saveTextScaleUseCase,
  ) : super(SettingsInitial());

  Future<void> checkSettings() async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) {
        // Emit loaded even if API key is missing, but flag it
        emit(SettingsLoaded(settings, isApiKeyMissing: settings.apiKey == null || settings.apiKey!.isEmpty));
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
}

