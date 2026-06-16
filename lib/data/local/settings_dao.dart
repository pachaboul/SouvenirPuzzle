import 'package:sqflite/sqflite.dart';

import 'app_database.dart';
import 'database_tables.dart';

/// Key/value data-access object for the `app_settings` table.
class SettingsDao {
  SettingsDao(this._db);

  final AppDatabase _db;

  Future<Map<String, String>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(DatabaseTables.appSettings);
    return {
      for (final row in rows) row['key'] as String: row['value'] as String,
    };
  }

  Future<void> set(String key, String value) async {
    final db = await _db.database;
    await db.insert(
      DatabaseTables.appSettings,
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
