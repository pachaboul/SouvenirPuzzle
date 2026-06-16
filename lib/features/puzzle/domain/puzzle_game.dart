import 'dart:math';

import 'puzzle_difficulty.dart';

/// Pure-Dart puzzle engine: holds the board state and the swap mechanic.
///
/// The board is a flat list of length [pieceCount]. `board[position]` stores
/// the *correct index* of the piece currently sitting at `position`. The puzzle
/// is solved when every piece is back home, i.e. `board[i] == i` for all `i`.
class PuzzleGame {
  PuzzleGame(this.difficulty, {Random? random}) : _random = random ?? Random() {
    reset();
  }

  final PuzzleDifficulty difficulty;
  final Random _random;

  late List<int> board;
  int moves = 0;

  int get size => difficulty.gridSize;
  int get pieceCount => difficulty.pieceCount;

  bool get isSolved {
    for (var i = 0; i < board.length; i++) {
      if (board[i] != i) return false;
    }
    return true;
  }

  /// Swaps the pieces at two board positions and counts it as one move.
  void swap(int a, int b) {
    if (a == b) return;
    final tmp = board[a];
    board[a] = board[b];
    board[b] = tmp;
    moves++;
  }

  /// Reshuffles the board (guaranteeing it does not start already solved).
  void reset() {
    moves = 0;
    board = List<int>.generate(pieceCount, (i) => i);
    if (pieceCount <= 1) return;
    do {
      board.shuffle(_random);
    } while (isSolved);
  }
}
