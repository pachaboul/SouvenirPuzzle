/// The difficulty levels available in the MVP, each mapped to a square grid.
enum PuzzleDifficulty {
  easy(gridSize: 3, label: 'Facile', audience: 'Enfants, seniors, débutants'),
  medium(gridSize: 4, label: 'Moyen', audience: 'Joueurs casual'),
  hard(gridSize: 5, label: 'Difficile', audience: 'Joueurs plus patients');

  const PuzzleDifficulty({
    required this.gridSize,
    required this.label,
    required this.audience,
  });

  /// Number of rows and columns (the grid is always square).
  final int gridSize;

  /// Human-readable name shown in the UI.
  final String label;

  /// Suggested audience, shown as a hint on the difficulty screen.
  final String audience;

  /// Total number of pieces for this difficulty.
  int get pieceCount => gridSize * gridSize;
}
