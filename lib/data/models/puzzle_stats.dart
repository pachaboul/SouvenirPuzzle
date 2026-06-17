import '../../features/puzzle/domain/puzzle_difficulty.dart';

/// Aggregate statistics across all memories and completed games.
class PuzzleStats {
  const PuzzleStats({
    required this.totalMemories,
    required this.totalCompleted,
    required this.totalTimeSeconds,
    required this.totalMoves,
    required this.winsByDifficulty,
    required this.bestTimeByDifficulty,
  });

  final int totalMemories;
  final int totalCompleted;
  final int totalTimeSeconds;
  final int totalMoves;
  final Map<PuzzleDifficulty, int> winsByDifficulty;
  final Map<PuzzleDifficulty, int?> bestTimeByDifficulty;

  bool get hasPlayed => totalCompleted > 0;
}
