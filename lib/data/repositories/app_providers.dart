import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/file_storage_service.dart';
import '../local/app_database.dart';

final fileStorageServiceProvider = Provider<FileStorageService>((ref) {
  return FileStorageService();
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
