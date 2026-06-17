import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/puzzle_stats.dart';
import 'app_providers.dart';
import 'profile_providers.dart';
import 'puzzle_repository.dart';

export 'app_providers.dart';
export 'profile_providers.dart';
export 'puzzle_repository.dart';

final puzzleRepositoryProvider = Provider<PuzzleRepository>((ref) {
  ref.watch(profileControllerProvider);
  return PuzzleRepository(
    database: ref.watch(appDatabaseProvider),
    storage: ref.watch(fileStorageServiceProvider),
    profileIdProvider: () =>
        ref.read(profileControllerProvider).requireValue.activeProfileId,
  );
});

final statsProvider = FutureProvider.autoDispose<PuzzleStats>((ref) {
  ref.watch(profileControllerProvider);
  return ref.watch(puzzleRepositoryProvider).getStats();
});
