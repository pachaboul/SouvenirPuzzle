import 'package:sqflite/sqflite.dart';

import '../models/puzzle_session_model.dart';
import 'app_database.dart';
import 'database_tables.dart';

/// Data-access object for the `puzzle_sessions` table.
class PuzzleSessionDao {
  PuzzleSessionDao(this._db);

  final AppDatabase _db;

  Future<void> insert(PuzzleSessionModel session) async {
    final db = await _db.database;
    await db.insert(
      DatabaseTables.puzzleSessions,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(PuzzleSessionModel session) async {
    final db = await _db.database;
    await db.update(
      DatabaseTables.puzzleSessions,
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  /// Most recently played (or created) first, for one profile.
  Future<List<PuzzleSessionModel>> getAll(String profileId) async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseTables.puzzleSessions,
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'COALESCE(last_played_at, created_at) DESC',
    );
    return rows.map(PuzzleSessionModel.fromMap).toList();
  }

  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.delete(
      DatabaseTables.puzzleSessions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllForProfile(String profileId) async {
    final db = await _db.database;
    await db.delete(
      DatabaseTables.puzzleSessions,
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
  }
}
