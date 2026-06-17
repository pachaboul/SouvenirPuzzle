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
      case PuzzleDifficulty.grandMaster:
        return PuzzleDifficulty.master;
      case PuzzleDifficulty.legend:
        return PuzzleDifficulty.grandMaster;
    }
  }

  /// The level unlocked immediately after [difficulty], or null for [legend].
  static PuzzleDifficulty? nextLevel(PuzzleDifficulty difficulty) {
    final values = PuzzleDifficulty.values;
    final index = values.indexOf(difficulty);
    if (index < 0 || index >= values.length - 1) return null;
    return values[index + 1];
  }

  /// Returns the newly unlocked level when a win at [completedAt] reaches
  /// [winsToUnlock], using the win count *before* that game was recorded.
  static PuzzleDifficulty? levelUnlockedByWin({
    required PuzzleDifficulty completedAt,
    required int winsBeforeAtLevel,
  }) {
    if (winsBeforeAtLevel + 1 != winsToUnlock) return null;
    return nextLevel(completedAt);
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

  /// The level the player is currently progressing (first unlocked under 99 wins).
  static PuzzleDifficulty activeLevel(Map<PuzzleDifficulty, int> wins) {
    var lastUnlocked = PuzzleDifficulty.easy;
    for (final difficulty in PuzzleDifficulty.values) {
      if (!isUnlocked(difficulty, wins)) break;
      lastUnlocked = difficulty;
      if ((wins[difficulty] ?? 0) < matchesPerLevel) return difficulty;
    }
    return lastUnlocked;
  }
}
