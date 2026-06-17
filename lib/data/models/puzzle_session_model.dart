/// Represents one puzzle "memory" created by the user.
class PuzzleSessionModel {
  const PuzzleSessionModel({
    required this.id,
    required this.profileId,
    required this.originalImageReference,
    required this.imagePath,
    required this.thumbnailPath,
    required this.difficulty,
    required this.rows,
    required this.columns,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.isCompleted,
    required this.bestTimeSeconds,
    required this.bestMoves,
    required this.playCount,
  });

  final String id;
  final String profileId;
  final String? originalImageReference;
  final String imagePath;
  final String? thumbnailPath;
  final String difficulty;
  final int rows;
  final int columns;
  final DateTime createdAt;
  final DateTime? lastPlayedAt;
  final bool isCompleted;
  final int? bestTimeSeconds;
  final int? bestMoves;
  final int playCount;

  PuzzleSessionModel copyWith({
    String? difficulty,
    int? rows,
    int? columns,
    DateTime? lastPlayedAt,
    bool? isCompleted,
    int? bestTimeSeconds,
    int? bestMoves,
    int? playCount,
  }) {
    return PuzzleSessionModel(
      id: id,
      profileId: profileId,
      originalImageReference: originalImageReference,
      imagePath: imagePath,
      thumbnailPath: thumbnailPath,
      difficulty: difficulty ?? this.difficulty,
      rows: rows ?? this.rows,
      columns: columns ?? this.columns,
      createdAt: createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      bestTimeSeconds: bestTimeSeconds ?? this.bestTimeSeconds,
      bestMoves: bestMoves ?? this.bestMoves,
      playCount: playCount ?? this.playCount,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'profile_id': profileId,
      'original_image_reference': originalImageReference,
      'image_path': imagePath,
      'thumbnail_path': thumbnailPath,
      'difficulty': difficulty,
      'rows': rows,
      'columns': columns,
      'created_at': createdAt.toIso8601String(),
      'last_played_at': lastPlayedAt?.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'best_time_seconds': bestTimeSeconds,
      'best_moves': bestMoves,
      'play_count': playCount,
    };
  }

  factory PuzzleSessionModel.fromMap(Map<String, Object?> map) {
    return PuzzleSessionModel(
      id: map['id'] as String,
      profileId: map['profile_id'] as String,
      originalImageReference: map['original_image_reference'] as String?,
      imagePath: map['image_path'] as String,
      thumbnailPath: map['thumbnail_path'] as String?,
      difficulty: map['difficulty'] as String,
      rows: map['rows'] as int,
      columns: map['columns'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastPlayedAt: map['last_played_at'] == null
          ? null
          : DateTime.parse(map['last_played_at'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
      bestTimeSeconds: map['best_time_seconds'] as int?,
      bestMoves: map['best_moves'] as int?,
      playCount: map['play_count'] as int,
    );
  }
}
