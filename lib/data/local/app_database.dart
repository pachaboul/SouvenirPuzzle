import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

/// Owns the SQLite connection and lazily opens it on first use.
class AppDatabase {
  AppDatabase();

  static const String _fileName = 'souvenir_puzzle.db';
  static const int _version = 1;

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
        await db.execute(DatabaseTables.createPuzzleSessions);
        await db.execute(DatabaseTables.createPuzzleResults);
        await db.execute(DatabaseTables.createAppSettings);
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
