import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/misc.dart';
import 'package:souvenir_puzzle/data/models/app_settings.dart';
import 'package:souvenir_puzzle/data/models/best_score.dart';
import 'package:souvenir_puzzle/data/models/puzzle_session_model.dart';
import 'package:souvenir_puzzle/data/models/puzzle_stats.dart';
import 'package:souvenir_puzzle/data/repositories/profile_providers.dart';
import 'package:souvenir_puzzle/data/repositories/profile_repository.dart';
import 'package:souvenir_puzzle/data/repositories/puzzle_providers.dart';
import 'package:souvenir_puzzle/data/repositories/settings_providers.dart';
import 'package:souvenir_puzzle/features/home/home_providers.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';

import 'screenshot_demo_data.dart';
import 'screenshot_puzzle_repository.dart';

class ScreenshotProfileController extends ProfileController {
  @override
  Future<ProfileState> build() async => ScreenshotDemoData.profileState;
}

class ScreenshotSettingsController extends SettingsController {
  ScreenshotSettingsController(this._settings);

  final AppSettings _settings;

  @override
  Future<AppSettings> build() async => _settings;
}

/// Riverpod overrides for screenshot widget tests.
List<Override> screenshotOverrides({
  required String imagePath,
  required AppSettings settings,
}) {
  final sessions = ScreenshotDemoData.memorySessions(imagePath);
  final repo = ScreenshotPuzzleRepository(
    sessions: sessions,
    wins: ScreenshotDemoData.demoWins,
    stats: ScreenshotDemoData.stats(),
    bests: {
      for (final s in sessions)
        s.id: {
          PuzzleDifficulty.easy: const BestScore(timeSeconds: 95, moves: 22, plays: 5),
          PuzzleDifficulty.medium: const BestScore(timeSeconds: 142, moves: 38, plays: 3),
        },
    },
  );

  return [
    profileControllerProvider.overrideWith(ScreenshotProfileController.new),
    settingsControllerProvider.overrideWith(
      () => ScreenshotSettingsController(settings),
    ),
    puzzleRepositoryProvider.overrideWithValue(repo),
    homeStateProvider.overrideWith(
      (ref) => Future.value(ScreenshotDemoData.homeState(imagePath)),
    ),
    statsProvider.overrideWith(
      (ref) => Future.value(ScreenshotDemoData.stats()),
    ),
  ];
}
