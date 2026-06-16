import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/file_storage_service.dart';
import '../local/app_database.dart';
import 'puzzle_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final puzzleRepositoryProvider = Provider<PuzzleRepository>((ref) {
  return PuzzleRepository(
    database: ref.watch(appDatabaseProvider),
    storage: FileStorageService(),
  );
});
