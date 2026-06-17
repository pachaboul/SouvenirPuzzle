import '../models/best_score.dart';
import '../models/puzzle_result_model.dart';
import 'app_database.dart';
import 'database_tables.dart';

/// Data-access object for the `puzzle_results` table.
class PuzzleResultDao {
  PuzzleResultDao(this._db);

  final AppDatabase _db;

  Future<void> insert(PuzzleResultModel result) async {
    final db = await _db.database;
    await db.insert(DatabaseTables.puzzleResults, result.toMap());
  }

  Future<List<PuzzleResultModel>> getForSession(String sessionId) async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseTables.puzzleResults,
      where: 'puzzle_session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'completed_at DESC',
    );
    return rows.map(PuzzleResultModel.fromMap).toList();
  }

  Future<Map<String, int>> countByDifficulty(String profileId) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT difficulty, COUNT(*) AS c '
      'FROM ${DatabaseTables.puzzleResults} '
      'WHERE profile_id = ? GROUP BY difficulty',
      [profileId],
    );
    return {
      for (final row in rows) row['difficulty'] as String: row['c'] as int,
    };
  }

  Future<Map<String, Map<String, BestScore>>> bestScoresBySession(
    String profileId,
  ) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT puzzle_session_id AS sid, difficulty, '
      'MIN(time_seconds) AS bt, MIN(moves) AS bm, COUNT(*) AS c '
      'FROM ${DatabaseTables.puzzleResults} '
      'WHERE profile_id = ? '
      'GROUP BY puzzle_session_id, difficulty',
      [profileId],
    );
    final result = <String, Map<String, BestScore>>{};
    for (final row in rows) {
      final sid = row['sid'] as String;
      final difficulty = row['difficulty'] as String;
      (result[sid] ??= {})[difficulty] = BestScore(
        timeSeconds: row['bt'] as int,
        moves: row['bm'] as int,
        plays: row['c'] as int,
      );
    }
    return result;
  }

  Future<({int completed, int totalTime, int totalMoves})> totals(
    String profileId,
  ) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c, COALESCE(SUM(time_seconds), 0) AS t, '
      'COALESCE(SUM(moves), 0) AS m FROM ${DatabaseTables.puzzleResults} '
      'WHERE profile_id = ?',
      [profileId],
    );
    final row = rows.first;
    return (
      completed: row['c'] as int,
      totalTime: row['t'] as int,
      totalMoves: row['m'] as int,
    );
  }

  Future<List<PuzzleResultModel>> getAllOrdered(String profileId) async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseTables.puzzleResults,
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'completed_at ASC',
    );
    return rows.map(PuzzleResultModel.fromMap).toList();
  }

  Future<Map<String, int>> bestTimeByDifficulty(String profileId) async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT difficulty, MIN(time_seconds) AS bt '
      'FROM ${DatabaseTables.puzzleResults} '
      'WHERE profile_id = ? GROUP BY difficulty',
      [profileId],
    );
    return {
      for (final row in rows) row['difficulty'] as String: row['bt'] as int,
    };
  }

  Future<void> deleteAllForProfile(String profileId) async {
    final db = await _db.database;
    await db.delete(
      DatabaseTables.puzzleResults,
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
  }
}
