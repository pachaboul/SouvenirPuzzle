import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_settings.dart';
import 'puzzle_providers.dart';
import 'settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
});

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

/// Loads the user's preferences and persists changes as they happen.
class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.watch(settingsRepositoryProvider).load();

  AppSettings get _current => state.asData?.value ?? const AppSettings();
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  Future<void> setSoundEnabled(bool value) async {
    await _repo.setSoundEnabled(value);
    state = AsyncData(_current.copyWith(soundEnabled: value));
  }

  Future<void> setVibrationEnabled(bool value) async {
    await _repo.setVibrationEnabled(value);
    state = AsyncData(_current.copyWith(vibrationEnabled: value));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.setThemeMode(mode);
    state = AsyncData(_current.copyWith(themeMode: mode));
  }

  Future<void> setLanguage(AppLanguage language) async {
    await _repo.setLanguage(language);
    state = AsyncData(_current.copyWith(language: language));
  }
}
