import 'puzzle_difficulty.dart';

/// Rules for unlocking difficulty levels.
///
/// Each level must be won [winsPerLevel] times before the next one unlocks:
/// Facile → Moyen → Difficile. Win counts are derived from `puzzle_results`.
class LevelProgression {
  LevelProgression._();

  static const int winsPerLevel = 12;

  /// The level whose wins gate [difficulty] (null for the first level).
  static PuzzleDifficulty? prerequisite(PuzzleDifficulty difficulty) {
    switch (difficulty) {
      case PuzzleDifficulty.easy:
        return null;
      case PuzzleDifficulty.medium:
        return PuzzleDifficulty.easy;
      case PuzzleDifficulty.hard:
        return PuzzleDifficulty.medium;
    }
  }

  /// Whether [difficulty] is unlocked given the [wins] per level.
  static bool isUnlocked(
    PuzzleDifficulty difficulty,
    Map<PuzzleDifficulty, int> wins,
  ) {
    final required = prerequisite(difficulty);
    if (required == null) return true;
    return (wins[required] ?? 0) >= winsPerLevel;
  }
}
