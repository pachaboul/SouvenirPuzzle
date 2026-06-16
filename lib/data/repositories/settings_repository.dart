import 'package:flutter/material.dart';

import '../local/app_database.dart';
import '../local/settings_dao.dart';
import '../models/app_settings.dart';

/// Reads and writes user preferences in the `app_settings` table.
class SettingsRepository {
  SettingsRepository(AppDatabase database) : _dao = SettingsDao(database);

  final SettingsDao _dao;

  static const String _kSound = 'sound_enabled';
  static const String _kVibration = 'vibration_enabled';
  static const String _kTheme = 'theme_mode';

  Future<AppSettings> load() async {
    final map = await _dao.getAll();
    return AppSettings(
      soundEnabled: (map[_kSound] ?? 'true') != 'false',
      vibrationEnabled: (map[_kVibration] ?? 'true') != 'false',
      themeMode: _parseThemeMode(map[_kTheme]),
    );
  }

  Future<void> setSoundEnabled(bool value) => _dao.set(_kSound, '$value');

  Future<void> setVibrationEnabled(bool value) =>
      _dao.set(_kVibration, '$value');

  Future<void> setThemeMode(ThemeMode mode) => _dao.set(_kTheme, mode.name);

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}
