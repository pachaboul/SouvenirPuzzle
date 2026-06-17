/// One completed play-through of a puzzle session.
class PuzzleResultModel {
  const PuzzleResultModel({
    required this.id,
    required this.profileId,
    required this.puzzleSessionId,
    required this.completedAt,
    required this.timeSeconds,
    required this.moves,
    required this.difficulty,
    required this.rows,
    required this.columns,
  });

  final String id;
  final String profileId;
  final String puzzleSessionId;
  final DateTime completedAt;
  final int timeSeconds;
  final int moves;
  final String difficulty;
  final int rows;
  final int columns;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'profile_id': profileId,
      'puzzle_session_id': puzzleSessionId,
      'completed_at': completedAt.toIso8601String(),
      'time_seconds': timeSeconds,
      'moves': moves,
      'difficulty': difficulty,
      'rows': rows,
      'columns': columns,
    };
  }

  factory PuzzleResultModel.fromMap(Map<String, Object?> map) {
    return PuzzleResultModel(
      id: map['id'] as String,
      profileId: map['profile_id'] as String,
      puzzleSessionId: map['puzzle_session_id'] as String,
      completedAt: DateTime.parse(map['completed_at'] as String),
      timeSeconds: map['time_seconds'] as int,
      moves: map['moves'] as int,
      difficulty: map['difficulty'] as String,
      rows: map['rows'] as int,
      columns: map['columns'] as int,
    );
  }
}
