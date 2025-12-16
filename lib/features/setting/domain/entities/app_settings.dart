import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String? apiKey;
  final DateTime? lastSyncTime;

  const AppSettings({
    this.apiKey,
    this.lastSyncTime,
  });

  AppSettings copyWith({
    String? apiKey,
    DateTime? lastSyncTime,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [apiKey, lastSyncTime];
}
