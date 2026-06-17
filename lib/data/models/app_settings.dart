import 'package:flutter/material.dart';

/// Language preference. `system` follows the device locale.
enum AppLanguage {
  system,
  french,
  english;

  /// The locale to force, or null to follow the system.
  Locale? get locale {
    switch (this) {
      case AppLanguage.system:
        return null;
      case AppLanguage.french:
        return const Locale('fr');
      case AppLanguage.english:
        return const Locale('en');
    }
  }
}

/// User preferences. Defaults follow the design doc (sound + vibration on,
/// light theme, system language).
class AppSettings {
  const AppSettings({
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.themeMode = ThemeMode.light,
    this.language = AppLanguage.system,
  });

  final bool soundEnabled;
  final bool vibrationEnabled;
  final ThemeMode themeMode;
  final AppLanguage language;

  AppSettings copyWith({
    bool? soundEnabled,
    bool? vibrationEnabled,
    ThemeMode? themeMode,
    AppLanguage? language,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}
