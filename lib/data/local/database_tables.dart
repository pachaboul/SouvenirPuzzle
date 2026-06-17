/// Table names and DDL for the local SQLite database.
///
/// Follows the MVP recommendation of *direct deletion* (no `deleted_at`).
class DatabaseTables {
  DatabaseTables._();

  static const String profiles = 'profiles';
  static const String puzzleSessions = 'puzzle_sessions';
  static const String puzzleResults = 'puzzle_results';
  static const String appSettings = 'app_settings';

  static const String createProfiles = '''
    CREATE TABLE $profiles (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      avatar_path TEXT,
      created_at TEXT NOT NULL
    );
  ''';

  static const String createPuzzleSessions = '''
    CREATE TABLE $puzzleSessions (
      id TEXT PRIMARY KEY,
      profile_id TEXT NOT NULL,
      original_image_reference TEXT,
      image_path TEXT NOT NULL,
      thumbnail_path TEXT,
      difficulty TEXT NOT NULL,
      rows INTEGER NOT NULL,
      columns INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      last_played_at TEXT,
      is_completed INTEGER NOT NULL DEFAULT 0,
      best_time_seconds INTEGER,
      best_moves INTEGER,
      play_count INTEGER NOT NULL DEFAULT 0,
      FOREIGN KEY (profile_id) REFERENCES $profiles(id)
    );
  ''';

  /// Results are kept when a memory is deleted so stats and level progression
  /// remain accurate (`puzzle_session_id` may reference a removed session).
  static const String createPuzzleResults = '''
    CREATE TABLE $puzzleResults (
      id TEXT PRIMARY KEY,
      profile_id TEXT NOT NULL,
      puzzle_session_id TEXT NOT NULL,
      completed_at TEXT NOT NULL,
      time_seconds INTEGER NOT NULL,
      moves INTEGER NOT NULL,
      difficulty TEXT NOT NULL,
      rows INTEGER NOT NULL,
      columns INTEGER NOT NULL,
      FOREIGN KEY (profile_id) REFERENCES $profiles(id)
    );
  ''';

  /// v1 → v2: drop CASCADE FK so deleting a memory no longer wipes its results.
  static const String migratePuzzleResultsDropCascade = '''
    CREATE TABLE ${puzzleResults}_v2 (
      id TEXT PRIMARY KEY,
      puzzle_session_id TEXT NOT NULL,
      completed_at TEXT NOT NULL,
      time_seconds INTEGER NOT NULL,
      moves INTEGER NOT NULL,
      difficulty TEXT NOT NULL,
      rows INTEGER NOT NULL,
      columns INTEGER NOT NULL
    );
  ''';

  static const String createAppSettings = '''
    CREATE TABLE $appSettings (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );
  ''';
}
