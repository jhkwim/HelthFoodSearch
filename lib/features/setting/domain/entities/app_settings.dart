import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String? apiKey;
  final DateTime? lastSyncTime;
  final double textScale;

  const AppSettings({
    this.apiKey,
    this.lastSyncTime,
    this.textScale = 1.0,
  });

  AppSettings copyWith({
    String? apiKey,
    DateTime? lastSyncTime,
    double? textScale,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      textScale: textScale ?? this.textScale,
    );
  }

  @override
  List<Object?> get props => [apiKey, lastSyncTime, textScale];
}
