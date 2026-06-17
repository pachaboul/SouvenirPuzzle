import 'puzzle_difficulty.dart';

/// Rules for unlocking difficulty levels.
///
/// Each level must be won [winsPerLevel] times before the next one unlocks:
/// Facile → Moyen → Difficile. Win counts are derived from `puzzle_results`.
class LevelProgression {
  LevelProgression._();

  /// Wins needed in a level to unlock the next one.
  static const int winsToUnlock = 33;

  /// Target number of matches per level (the level's completion goal).
  static const int matchesPerLevel = 99;

  /// The level whose wins gate [difficulty] (null for the first level).
  static PuzzleDifficulty? prerequisite(PuzzleDifficulty difficulty) {
    switch (difficulty) {
      case PuzzleDifficulty.easy:
        return null;
      case PuzzleDifficulty.medium:
        return PuzzleDifficulty.easy;
      case PuzzleDifficulty.hard:
        return PuzzleDifficulty.medium;
      case PuzzleDifficulty.expert:
        return PuzzleDifficulty.hard;
      case PuzzleDifficulty.master:
        return PuzzleDifficulty.expert;
    }
  }

  /// Whether [difficulty] is unlocked given the [wins] per level.
  static bool isUnlocked(
    PuzzleDifficulty difficulty,
    Map<PuzzleDifficulty, int> wins,
  ) {
    final required = prerequisite(difficulty);
    if (required == null) return true;
    return (wins[required] ?? 0) >= winsToUnlock;
  }
}
