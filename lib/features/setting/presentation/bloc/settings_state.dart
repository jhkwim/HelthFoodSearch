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
  final double? refinementProgress; // null = idle, 0.0-1.0 = progressing

  const SettingsLoaded(this.settings, {
    this.isApiKeyMissing = false,
    this.appVersion = '',
    this.refinementProgress,
  });

  @override
  List<Object?> get props => [settings, isApiKeyMissing, appVersion, refinementProgress];
  
  SettingsLoaded copyWith({
    AppSettings? settings,
    bool? isApiKeyMissing,
    String? appVersion,
    double? refinementProgress,
  }) {
    return SettingsLoaded(
      settings ?? this.settings,
      isApiKeyMissing: isApiKeyMissing ?? this.isApiKeyMissing,
      appVersion: appVersion ?? this.appVersion,
      refinementProgress: refinementProgress, // explicit null override not needed for this usage, usually strictly setting it. 
      // But for "resetting" to null, we might need a way.
      // actually copyWith is usually matching non-null.
      // Let's rely on creating new instances in Cubit for clarity.
      // But copyWith is useful.
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
