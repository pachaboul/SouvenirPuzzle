import '../models/user_profile.dart';
import 'app_database.dart';
import 'database_tables.dart';

class ProfileDao {
  ProfileDao(this._db);

  final AppDatabase _db;

  Future<void> insert(UserProfile profile) async {
    final db = await _db.database;
    await db.insert(DatabaseTables.profiles, profile.toMap());
  }

  Future<void> update(UserProfile profile) async {
    final db = await _db.database;
    await db.update(
      DatabaseTables.profiles,
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<List<UserProfile>> getAll() async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseTables.profiles,
      orderBy: 'created_at ASC',
    );
    return rows.map(UserProfile.fromMap).toList();
  }

  Future<UserProfile?> getById(String id) async {
    final db = await _db.database;
    final rows = await db.query(
      DatabaseTables.profiles,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserProfile.fromMap(rows.first);
  }

  Future<int> count() async {
    final db = await _db.database;
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM ${DatabaseTables.profiles}',
    );
    return rows.first['c'] as int;
  }

  Future<void> delete(String id) async {
    final db = await _db.database;
    await db.delete(
      DatabaseTables.profiles,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
