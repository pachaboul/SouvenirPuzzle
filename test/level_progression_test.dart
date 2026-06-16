import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/level_progression.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';

void main() {
  group('LevelProgression', () {
    test('easy is always unlocked', () {
      expect(LevelProgression.isUnlocked(PuzzleDifficulty.easy, {}), isTrue);
    });

    test('medium unlocks after 12 easy wins', () {
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.medium, {
          PuzzleDifficulty.easy: 11,
        }),
        isFalse,
      );
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.medium, {
          PuzzleDifficulty.easy: 12,
        }),
        isTrue,
      );
    });

    test('hard unlocks after 12 medium wins', () {
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.hard, {
          PuzzleDifficulty.easy: 50,
          PuzzleDifficulty.medium: 11,
        }),
        isFalse,
      );
      expect(
        LevelProgression.isUnlocked(PuzzleDifficulty.hard, {
          PuzzleDifficulty.medium: 12,
        }),
        isTrue,
      );
    });

    test('prerequisite chain', () {
      expect(LevelProgression.prerequisite(PuzzleDifficulty.easy), isNull);
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.medium),
        PuzzleDifficulty.easy,
      );
      expect(
        LevelProgression.prerequisite(PuzzleDifficulty.hard),
        PuzzleDifficulty.medium,
      );
    });
  });
}
