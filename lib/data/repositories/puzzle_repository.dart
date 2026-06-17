import 'dart:io';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../core/services/file_storage_service.dart';
import '../../features/puzzle/domain/puzzle_difficulty.dart';
import '../local/app_database.dart';
import '../local/puzzle_result_dao.dart';
import '../local/puzzle_session_dao.dart';
import '../models/best_score.dart';
import '../models/puzzle_result_model.dart';
import '../models/puzzle_session_model.dart';
import '../models/puzzle_stats.dart';

/// Coordinates the database and local file storage for puzzle memories.
class PuzzleRepository {
  PuzzleRepository({
    required AppDatabase database,
    required FileStorageService storage,
  })  : _sessions = PuzzleSessionDao(database),
        _results = PuzzleResultDao(database),
        _storage = storage;

  final PuzzleSessionDao _sessions;
  final PuzzleResultDao _results;
  final FileStorageService _storage;
  final Uuid _uuid = const Uuid();

  /// Creates a new memory: copies the photo locally, builds a thumbnail, and
  /// persists the session row.
  Future<PuzzleSessionModel> createSession({
    required File sourceImage,
    required PuzzleDifficulty difficulty,
  }) async {
    final id = _uuid.v4();
    final imagePath = await _storage.saveOptimizedImage(id, sourceImage);
    final thumbnailPath = await _storage.saveThumbnail(id, sourceImage);
    final now = DateTime.now();

    final session = PuzzleSessionModel(
      id: id,
      originalImageReference: sourceImage.path,
      imagePath: imagePath,
      thumbnailPath: thumbnailPath,
      difficulty: difficulty.name,
      rows: difficulty.gridSize,
      columns: difficulty.gridSize,
      createdAt: now,
      lastPlayedAt: now,
      isCompleted: false,
      bestTimeSeconds: null,
      bestMoves: null,
      playCount: 0,
    );
    await _sessions.insert(session);
    return session;
  }

  /// Records a finished play-through (at the chosen [difficulty]) and updates
  /// the session's best scores and last-played difficulty.
  Future<void> recordResult({
    required PuzzleSessionModel session,
    required PuzzleDifficulty difficulty,
    required int seconds,
    required int moves,
  }) async {
    final now = DateTime.now();
    await _results.insert(
      PuzzleResultModel(
        id: _uuid.v4(),
        puzzleSessionId: session.id,
        completedAt: now,
        timeSeconds: seconds,
        moves: moves,
        difficulty: difficulty.name,
        rows: difficulty.gridSize,
        columns: difficulty.gridSize,
      ),
    );

    final bestTime = session.bestTimeSeconds == null
        ? seconds
        : min(session.bestTimeSeconds!, seconds);
    final bestMoves =
        session.bestMoves == null ? moves : min(session.bestMoves!, moves);

    await _sessions.update(
      session.copyWith(
        difficulty: difficulty.name,
        rows: difficulty.gridSize,
        columns: difficulty.gridSize,
        isCompleted: true,
        lastPlayedAt: now,
        bestTimeSeconds: bestTime,
        bestMoves: bestMoves,
        playCount: session.playCount + 1,
      ),
    );
  }

  /// Wins per difficulty level, derived from completed results.
  Future<Map<PuzzleDifficulty, int>> winsByDifficulty() async {
    final counts = await _results.countByDifficulty();
    return {
      for (final d in PuzzleDifficulty.values) d: counts[d.name] ?? 0,
    };
  }

  /// Best time / moves per session and difficulty, keyed by session id.
  Future<Map<String, Map<PuzzleDifficulty, BestScore>>>
      bestScoresBySession() async {
    final raw = await _results.bestScoresBySession();
    return raw.map(
      (sid, byName) => MapEntry(sid, {
        for (final entry in byName.entries)
          PuzzleDifficulty.values.byName(entry.key): entry.value,
      }),
    );
  }

  /// Aggregate statistics for the stats page.
  Future<PuzzleStats> getStats() async {
    final sessions = await _sessions.getAll();
    final totals = await _results.totals();
    final winsByName = await _results.countByDifficulty();
    final bestByName = await _results.bestTimeByDifficulty();
    return PuzzleStats(
      totalMemories: sessions.length,
      totalCompleted: totals.completed,
      totalTimeSeconds: totals.totalTime,
      totalMoves: totals.totalMoves,
      winsByDifficulty: {
        for (final d in PuzzleDifficulty.values) d: winsByName[d.name] ?? 0,
      },
      bestTimeByDifficulty: {
        for (final d in PuzzleDifficulty.values) d: bestByName[d.name],
      },
    );
  }

  Future<List<PuzzleSessionModel>> getSessions() => _sessions.getAll();

  /// Deletes a memory: removes the row (results cascade) and its local files.
  /// The original gallery photo is never touched.
  Future<void> deleteSession(PuzzleSessionModel session) async {
    await _sessions.delete(session.id);
    await _storage.deleteFile(session.imagePath);
    await _storage.deleteFile(session.thumbnailPath);
  }

  /// Deletes every memory and its local files (used by "effacer l'historique").
  Future<void> clearAllSessions() async {
    final sessions = await _sessions.getAll();
    for (final session in sessions) {
      await deleteSession(session);
    }
  }
}
