import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/level_progression.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';

void main() {
  group('LevelProgression', () {
    test('easy is always unlocked', () {
      expect(LevelProgression.isUnlocked(PuzzleDifficulty.easy, {}), isTrue);
    });

    test('next level unlocks after 33 wins in the previous one', () {
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.medium, {
          PuzzleDifficulty.easy: 32,
        }),
        isFalse,
      );
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.medium, {
          PuzzleDifficulty.easy: 33,
        }),
        isTrue,
      );
    });

    test('expert and master require 33 wins in their prerequisite', () {
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.expert, {
          PuzzleDifficulty.hard: 33,
        }),
        isTrue,
      );
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.master, {
          PuzzleDifficulty.expert: 32,
        }),
        isFalse,
      );
    });

    test('prerequisite chain covers all levels', () {
      expect(LevelProgression.prerequisite(PuzzleDifficulty.easy), isNull);
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.medium),
        PuzzleDifficulty.easy,
      );
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.hard),
        PuzzleDifficulty.medium,
      );
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.expert),
        PuzzleDifficulty.hard,
      );
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.master),
        PuzzleDifficulty.expert,
      );
    });

    test('constants', () {
      expect(LevelProgression.winsToUnlock, 33);
      expect(LevelProgression.matchesPerLevel, 99);
    });
  });
}
