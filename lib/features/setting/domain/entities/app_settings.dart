import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  final String? apiKey;
  final DateTime? lastSyncTime;
  final double textScale;
  final int updateIntervalDays;
  final ThemeMode themeMode; // New field
  final DateTime? lastRefinementUpdate; // New field

  const AppSettings({
    this.apiKey,
    this.lastSyncTime,
    this.textScale = 1.0,
    this.updateIntervalDays = 30,
    this.themeMode = ThemeMode.system,
    this.lastRefinementUpdate,
  });

  AppSettings copyWith({
    String? apiKey,
    DateTime? lastSyncTime,
    double? textScale,
    int? updateIntervalDays,
    ThemeMode? themeMode,
    DateTime? lastRefinementUpdate,
  }) {
    return AppSettings(
      apiKey: apiKey ?? this.apiKey,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      textScale: textScale ?? this.textScale,
      updateIntervalDays: updateIntervalDays ?? this.updateIntervalDays,
      themeMode: themeMode ?? this.themeMode,
      lastRefinementUpdate: lastRefinementUpdate ?? this.lastRefinementUpdate,
    );
  }

  @override
  List<Object?> get props => [
    apiKey,
    lastSyncTime,
    textScale,
    updateIntervalDays,
    themeMode,
    lastRefinementUpdate,
  ];
}
