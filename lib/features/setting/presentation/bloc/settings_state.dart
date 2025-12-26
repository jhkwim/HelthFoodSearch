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
  final DateTime? lastRefinementUpdate;

  const SettingsLoaded(
    this.settings, {
    this.isApiKeyMissing = false,
    this.appVersion = '',
    this.refinementProgress,
    this.lastRefinementUpdate,
  });

  @override
  List<Object?> get props => [
    settings,
    isApiKeyMissing,
    appVersion,
    refinementProgress,
    lastRefinementUpdate,
  ];

  SettingsLoaded copyWith({
    AppSettings? settings,
    bool? isApiKeyMissing,
    String? appVersion,
    double? refinementProgress,
    DateTime? lastRefinementUpdate,
  }) {
    return SettingsLoaded(
      settings ?? this.settings,
      isApiKeyMissing: isApiKeyMissing ?? this.isApiKeyMissing,
      appVersion: appVersion ?? this.appVersion,
      refinementProgress: refinementProgress ?? this.refinementProgress,
      lastRefinementUpdate: lastRefinementUpdate ?? this.lastRefinementUpdate,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
