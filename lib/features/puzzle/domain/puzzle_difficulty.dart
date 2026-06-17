/// The difficulty levels available in the MVP, each mapped to a square grid.
///
/// Display names and audiences are localized — see `DifficultyL10n`.
enum PuzzleDifficulty {
  easy(gridSize: 3),
  medium(gridSize: 4),
  hard(gridSize: 5),
  expert(gridSize: 6),
  master(gridSize: 7),
  grandMaster(gridSize: 8),
  legend(gridSize: 9);

  const PuzzleDifficulty({required this.gridSize});

  /// Number of rows and columns (the grid is always square).
  final int gridSize;

  /// Total number of pieces for this difficulty.
  int get pieceCount => gridSize * gridSize;

  /// Seconds allowed before the match is lost (scales with grid size).
  int get timeLimitSeconds => gridSize * 60;
}
