import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_game.dart';

void main() {
  group('PuzzleGame', () {
    test('starts shuffled (not already solved)', () {
      // Seeded RNG keeps the test deterministic.
      final game = PuzzleGame(PuzzleDifficulty.medium, random: Random(42));
      expect(game.isSolved, isFalse);
      expect(game.board.length, PuzzleDifficulty.medium.pieceCount);
      expect(game.moves, 0);
    });

    test('swap exchanges two positions and counts a move', () {
      final game = PuzzleGame(PuzzleDifficulty.easy, random: Random(1));
      final a = game.board[0];
      final b = game.board[1];

      game.swap(0, 1);

      expect(game.board[0], b);
      expect(game.board[1], a);
      expect(game.moves, 1);
    });

    test('swapping a position with itself is a no-op', () {
      final game = PuzzleGame(PuzzleDifficulty.easy, random: Random(1));
      game.swap(2, 2);
      expect(game.moves, 0);
    });

    test('isSolved becomes true when every piece is home', () {
      final game = PuzzleGame(PuzzleDifficulty.easy, random: Random(1));
      for (var i = 0; i < game.board.length; i++) {
        game.board[i] = i;
      }
      expect(game.isSolved, isTrue);
    });

    test('reset reshuffles and clears the move counter', () {
      final game = PuzzleGame(PuzzleDifficulty.hard, random: Random(7));
      game.swap(0, 1);
      game.reset();
      expect(game.moves, 0);
      expect(game.isSolved, isFalse);
    });
  });
}
