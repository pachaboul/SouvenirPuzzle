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

    test('levelUnlockedByWin detects the 33rd win on a level', () {
      expect(
        LevelProgression.levelUnlockedByWin(
          completedAt: PuzzleDifficulty.easy,
          winsBeforeAtLevel: 32,
        ),
        PuzzleDifficulty.medium,
      );
      expect(
        LevelProgression.levelUnlockedByWin(
          completedAt: PuzzleDifficulty.easy,
          winsBeforeAtLevel: 33,
        ),
        isNull,
      );
      expect(
        LevelProgression.levelUnlockedByWin(
          completedAt: PuzzleDifficulty.legend,
          winsBeforeAtLevel: 32,
        ),
        isNull,
      );
    });

    test('activeLevel picks first unlocked level under 99 wins', () {
      expect(
        LevelProgression.activeLevel({PuzzleDifficulty.easy: 10}),
        PuzzleDifficulty.easy,
      );
      expect(
        LevelProgression.activeLevel({
          PuzzleDifficulty.easy: 99,
          PuzzleDifficulty.medium: 5,
        }),
        PuzzleDifficulty.medium,
      );
      expect(
        LevelProgression.activeLevel({
          PuzzleDifficulty.easy: 99,
          PuzzleDifficulty.medium: 99,
          PuzzleDifficulty.hard: 20,
        }),
        PuzzleDifficulty.hard,
      );
    });

    test('constants', () {
      expect(LevelProgression.winsToUnlock, 33);
      expect(LevelProgression.matchesPerLevel, 99);
    });
  });
}
