import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String? apiKey;
  final DateTime? lastSyncTime;
  final double textScale;
  final int updateIntervalDays;

  const AppSettings({
    this.apiKey,
    this.lastSyncTime,
    this.textScale = 1.0,
    this.updateIntervalDays = 30,
  });

  AppSettings copyWith({
    String? apiKey,
    DateTime? lastSyncTime,
    double? textScale,
    int? updateIntervalDays,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      textScale: textScale ?? this.textScale,
      updateIntervalDays: updateIntervalDays ?? this.updateIntervalDays,
    );
  }

  @override
  List<Object?> get props => [apiKey, lastSyncTime, textScale, updateIntervalDays];
}
