import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_profile.dart';
import 'database_tables.dart';

/// Owns the SQLite connection and lazily opens it on first use.
class AppDatabase {
  AppDatabase();

  static const String _fileName = 'souvenir_puzzle.db';
  static const int _version = 3;

  Database? _db;

  Future<Database> get database async => _db ??= await _open();

  Future<Database> _open() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'souvenir_puzzle'));
    if (!dir.existsSync()) await dir.create(recursive: true);
    final path = p.join(dir.path, _fileName);

    return openDatabase(
      path,
      version: _version,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute(DatabaseTables.createProfiles);
        await db.execute(DatabaseTables.createPuzzleSessions);
        await db.execute(DatabaseTables.createPuzzleResults);
        await db.execute(DatabaseTables.createAppSettings);
        await _seedDefaultProfile(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await _migrateToV2(db);
        if (oldVersion < 3) await _migrateToV3(db);
      },
    );
  }

  static Future<void> _seedDefaultProfile(Database db) async {
    final now = DateTime.now().toIso8601String();
    await db.insert(DatabaseTables.profiles, {
      'id': ProfileIds.legacyDefault,
      'name': 'Joueur',
      'avatar_path': null,
      'created_at': now,
    });
    await db.insert(DatabaseTables.appSettings, {
      'key': 'active_profile_id',
      'value': ProfileIds.legacyDefault,
      'updated_at': now,
    });
  }

  /// Removes the CASCADE foreign key on [puzzle_results] (stats survive memory deletion).
  static Future<void> _migrateToV2(Database db) async {
    await db.execute(DatabaseTables.migratePuzzleResultsDropCascade);
    await db.execute('''
      INSERT INTO ${DatabaseTables.puzzleResults}_v2
        (id, puzzle_session_id, completed_at, time_seconds, moves,
         difficulty, rows, columns)
      SELECT id, puzzle_session_id, completed_at, time_seconds, moves,
             difficulty, rows, columns
      FROM ${DatabaseTables.puzzleResults};
    ''');
    await db.execute('DROP TABLE ${DatabaseTables.puzzleResults};');
    await db.execute(
      'ALTER TABLE ${DatabaseTables.puzzleResults}_v2 '
      'RENAME TO ${DatabaseTables.puzzleResults};',
    );
  }

  /// Adds local multi-profile support.
  static Future<void> _migrateToV3(Database db) async {
    await db.execute(DatabaseTables.createProfiles);

    final now = DateTime.now().toIso8601String();
    await db.insert(DatabaseTables.profiles, {
      'id': ProfileIds.legacyDefault,
      'name': 'Joueur',
      'avatar_path': null,
      'created_at': now,
    });

    await db.execute(
      "ALTER TABLE ${DatabaseTables.puzzleSessions} "
      "ADD COLUMN profile_id TEXT NOT NULL DEFAULT '${ProfileIds.legacyDefault}'",
    );
    await db.execute(
      "ALTER TABLE ${DatabaseTables.puzzleResults} "
      "ADD COLUMN profile_id TEXT NOT NULL DEFAULT '${ProfileIds.legacyDefault}'",
    );

    final existingActive = await db.query(
      DatabaseTables.appSettings,
      where: 'key = ?',
      whereArgs: ['active_profile_id'],
      limit: 1,
    );
    if (existingActive.isEmpty) {
      await db.insert(DatabaseTables.appSettings, {
        'key': 'active_profile_id',
        'value': ProfileIds.legacyDefault,
        'updated_at': now,
      });
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
