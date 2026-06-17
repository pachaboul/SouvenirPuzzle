import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/puzzle_session_model.dart';
import '../../data/repositories/puzzle_providers.dart';
import '../puzzle/domain/level_progression.dart';
import '../puzzle/domain/puzzle_difficulty.dart';

/// Snapshot of progression and last-played memory for the home tab.
class HomeState {
  const HomeState({
    required this.wins,
    required this.lastSession,
    required this.memoryCount,
  });

  final Map<PuzzleDifficulty, int> wins;
  final PuzzleSessionModel? lastSession;
  final int memoryCount;

  bool get hasMemories => memoryCount > 0;

  bool get canResume => lastSession != null && hasMemories;

  PuzzleDifficulty get activeLevel => LevelProgression.activeLevel(wins);

  int get levelWins => wins[activeLevel] ?? 0;

  PuzzleDifficulty? get nextLevel => LevelProgression.nextLevel(activeLevel);

  double get levelProgressFraction =>
      (levelWins / LevelProgression.matchesPerLevel).clamp(0.0, 1.0);

  double get unlockProgressFraction {
    if (nextLevel == null) return 1;
    return (levelWins / LevelProgression.winsToUnlock).clamp(0.0, 1.0);
  }
}

final homeStateProvider = FutureProvider.autoDispose<HomeState>((ref) async {
  ref.watch(profileControllerProvider);
  final repo = ref.watch(puzzleRepositoryProvider);
  final sessions = await repo.getSessions();
  final wins = await repo.winsByDifficulty();
  return HomeState(
    wins: wins,
    lastSession: sessions.isEmpty ? null : sessions.first,
    memoryCount: sessions.length,
  );
});
