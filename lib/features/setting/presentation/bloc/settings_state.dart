part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  final bool isApiKeyMissing;
  final String appVersion;

  const SettingsLoaded(this.settings, {
    this.isApiKeyMissing = false,
    this.appVersion = '',
  });

  @override
  List<Object?> get props => [settings, isApiKeyMissing, appVersion];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
