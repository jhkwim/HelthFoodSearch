import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../core/usecases/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/save_api_key_usecase.dart';

part 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveApiKeyUseCase saveApiKeyUseCase;

  SettingsCubit(this.getSettingsUseCase, this.saveApiKeyUseCase) : super(SettingsInitial());

  Future<void> checkSettings() async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) {
        if (settings.apiKey != null && settings.apiKey!.isNotEmpty) {
          emit(SettingsLoaded(settings));
        } else {
          emit(const SettingsLoaded(AppSettings(), isApiKeyMissing: true));
        }
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
}
