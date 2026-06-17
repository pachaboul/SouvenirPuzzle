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
    required String Function() profileIdProvider,
  })  : _sessions = PuzzleSessionDao(database),
        _results = PuzzleResultDao(database),
        _storage = storage,
        _profileIdProvider = profileIdProvider;

  final PuzzleSessionDao _sessions;
  final PuzzleResultDao _results;
  final FileStorageService _storage;
  final String Function() _profileIdProvider;
  final Uuid _uuid = const Uuid();

  String get _profileId => _profileIdProvider();

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
      profileId: _profileId,
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
        profileId: _profileId,
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
    final counts = await _results.countByDifficulty(_profileId);
    return {
      for (final d in PuzzleDifficulty.values) d: counts[d.name] ?? 0,
    };
  }

  /// Best time / moves per session and difficulty, keyed by session id.
  Future<Map<String, Map<PuzzleDifficulty, BestScore>>>
      bestScoresBySession() async {
    final raw = await _results.bestScoresBySession(_profileId);
    return raw.map(
      (sid, byName) => MapEntry(sid, {
        for (final entry in byName.entries)
          PuzzleDifficulty.values.byName(entry.key): entry.value,
      }),
    );
  }

  /// Aggregate statistics for the stats page.
  Future<PuzzleStats> getStats() async {
    final sessions = await _sessions.getAll(_profileId);
    final totals = await _results.totals(_profileId);
    final winsByName = await _results.countByDifficulty(_profileId);
    final bestByName = await _results.bestTimeByDifficulty(_profileId);
    final results = await _results.getAllOrdered(_profileId);
    final dailyActivity = _buildDailyActivity(results, PuzzleStats.maxActivityDays);
    final activeDays = results.map((r) => _dateOnly(r.completedAt)).toSet();

    PuzzleDifficulty? favorite;
    var maxWins = 0;
    for (final d in PuzzleDifficulty.values) {
      final w = winsByName[d.name] ?? 0;
      if (w > maxWins) {
        maxWins = w;
        favorite = d;
      }
    }

    DailyStatsPoint? peak;
    for (final point in dailyActivity) {
      if (peak == null || point.wins > peak.wins) peak = point;
    }
    if (peak != null && peak.wins == 0) peak = null;

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
      dailyActivity: dailyActivity,
      currentStreak: _computeStreak(activeDays),
      bestStreak: _computeBestStreak(activeDays),
      avgTimeSeconds:
          totals.completed > 0 ? totals.totalTime ~/ totals.completed : null,
      winsThisWeek: _winsInRange(results, 0, 6),
      winsLastWeek: _winsInRange(results, 7, 13),
      favoriteDifficulty: favorite,
      peakDay: peak,
    );
  }

  static int _winsInRange(
    List<PuzzleResultModel> results,
    int daysAgoStart,
    int daysAgoEnd,
  ) {
    final today = _dateOnly(DateTime.now());
    final start = today.subtract(Duration(days: daysAgoEnd));
    final end = today.subtract(Duration(days: daysAgoStart));
    return results.where((r) {
      final day = _dateOnly(r.completedAt);
      return !day.isBefore(start) && !day.isAfter(end);
    }).length;
  }

  static int _computeBestStreak(Set<DateTime> activeDays) {
    if (activeDays.isEmpty) return 0;
    final sorted = activeDays.toList()..sort();
    var best = 1;
    var current = 1;
    for (var i = 1; i < sorted.length; i++) {
      if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
        current++;
        if (current > best) best = current;
      } else {
        current = 1;
      }
    }
    return best;
  }

  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  static List<DailyStatsPoint> _buildDailyActivity(
    List<PuzzleResultModel> results,
    int days,
  ) {
    final today = _dateOnly(DateTime.now());
    final start = today.subtract(Duration(days: days - 1));

    final winsByDay = <DateTime, List<int>>{};
    for (final result in results) {
      final day = _dateOnly(result.completedAt);
      if (day.isBefore(start)) continue;
      (winsByDay[day] ??= []).add(result.timeSeconds);
    }

    return List.generate(days, (i) {
      final day = start.add(Duration(days: i));
      final times = winsByDay[day];
      final wins = times?.length ?? 0;
      final avg = wins > 0
          ? times!.reduce((a, b) => a + b) ~/ wins
          : null;
      return DailyStatsPoint(date: day, wins: wins, avgTimeSeconds: avg);
    });
  }

  static int _computeStreak(Set<DateTime> activeDays) {
    if (activeDays.isEmpty) return 0;

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    late final DateTime anchor;
    if (activeDays.contains(today)) {
      anchor = today;
    } else if (activeDays.contains(yesterday)) {
      anchor = yesterday;
    } else {
      return 0;
    }

    var streak = 0;
    var day = anchor;
    while (activeDays.contains(day)) {
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<List<PuzzleSessionModel>> getSessions() =>
      _sessions.getAll(_profileId);

  /// Deletes a memory and its local files. Completed-game rows in
  /// [puzzle_results] are kept so stats and level progression are unchanged.
  /// The original gallery photo is never touched.
  Future<void> deleteSession(PuzzleSessionModel session) async {
    await _sessions.delete(session.id);
    await _storage.deleteFile(session.imagePath);
    await _storage.deleteFile(session.thumbnailPath);
  }

  /// Deletes every memory and its local files (used by "effacer l'historique").
  /// Stats and win counts are preserved.
  Future<void> clearAllSessions() async {
    final sessions = await _sessions.getAll(_profileId);
    for (final session in sessions) {
      await deleteSession(session);
    }
  }
}
