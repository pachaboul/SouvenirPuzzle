import 'dart:io';

import 'package:souvenir_puzzle/core/services/file_storage_service.dart';
import 'package:souvenir_puzzle/data/local/app_database.dart';
import 'package:souvenir_puzzle/data/models/best_score.dart';
import 'package:souvenir_puzzle/data/models/puzzle_session_model.dart';
import 'package:souvenir_puzzle/data/models/puzzle_stats.dart';
import 'package:souvenir_puzzle/data/models/user_profile.dart';
import 'package:souvenir_puzzle/data/repositories/puzzle_repository.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';

/// In-memory puzzle data for screenshot tests (no SQLite).
class ScreenshotPuzzleRepository extends PuzzleRepository {
  ScreenshotPuzzleRepository({
    required this.sessions,
    required this.wins,
    required this.stats,
    required this.bests,
  }) : super(
          database: AppDatabase(),
          storage: FileStorageService(),
          profileIdProvider: () => ProfileIds.legacyDefault,
        );

  final List<PuzzleSessionModel> sessions;
  final Map<PuzzleDifficulty, int> wins;
  final PuzzleStats stats;
  final Map<String, Map<PuzzleDifficulty, BestScore>> bests;

  @override
  Future<List<PuzzleSessionModel>> getSessions() async => sessions;

  @override
  Future<Map<PuzzleDifficulty, int>> winsByDifficulty() async => wins;

  @override
  Future<PuzzleStats> getStats() async => stats;

  @override
  Future<Map<String, Map<PuzzleDifficulty, BestScore>>>
      bestScoresBySession() async => bests;

  @override
  Future<PuzzleSessionModel> createSession({
    required File sourceImage,
    required PuzzleDifficulty difficulty,
  }) {
    throw UnsupportedError('createSession');
  }

  @override
  Future<void> recordResult({
    required PuzzleSessionModel session,
    required PuzzleDifficulty difficulty,
    required int seconds,
    required int moves,
  }) {
    throw UnsupportedError('recordResult');
  }

  @override
  Future<void> deleteSession(PuzzleSessionModel session) {
    throw UnsupportedError('deleteSession');
  }

  @override
  Future<void> clearAllSessions() {
    throw UnsupportedError('clearAllSessions');
  }
}
