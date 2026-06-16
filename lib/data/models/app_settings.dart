import 'package:flutter/material.dart';

/// User preferences. Defaults follow the design doc (sound + vibration on,
/// light theme).
class AppSettings {
  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.themeMode = ThemeMode.light,
  });

  final bool soundEnabled;
  final bool vibrationEnabled;
  final ThemeMode themeMode;

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
