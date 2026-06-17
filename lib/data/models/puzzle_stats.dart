import '../../features/puzzle/domain/puzzle_difficulty.dart';

/// One day of activity for timeline charts.
class DailyStatsPoint {
  const DailyStatsPoint({
    required this.date,
    required this.wins,
    this.avgTimeSeconds,
  });

  final DateTime date;
  final int wins;
  final int? avgTimeSeconds;
}

/// Aggregate statistics across all memories and completed games.
class PuzzleStats {
  const PuzzleStats({
    required this.totalMemories,
    required this.totalCompleted,
    required this.totalTimeSeconds,
    required this.totalMoves,
    required this.winsByDifficulty,
    required this.bestTimeByDifficulty,
    required this.dailyActivity,
    required this.currentStreak,
    required this.bestStreak,
    required this.avgTimeSeconds,
    required this.winsThisWeek,
    required this.winsLastWeek,
    required this.favoriteDifficulty,
    required this.peakDay,
  });

  static const int maxActivityDays = 30;

  final int totalMemories;
  final int totalCompleted;
  final int totalTimeSeconds;
  final int totalMoves;
  final Map<PuzzleDifficulty, int> winsByDifficulty;
  final Map<PuzzleDifficulty, int?> bestTimeByDifficulty;
  final List<DailyStatsPoint> dailyActivity;
  final int currentStreak;
  final int bestStreak;
  final int? avgTimeSeconds;
  final int winsThisWeek;
  final int winsLastWeek;
  final PuzzleDifficulty? favoriteDifficulty;
  final DailyStatsPoint? peakDay;

  bool get hasPlayed => totalCompleted > 0;

  int get maxDailyWins =>
      dailyActivity.fold(0, (max, p) => p.wins > max ? p.wins : max);

  int get maxDifficultyWins => winsByDifficulty.values.fold(
        0,
        (max, w) => w > max ? w : max,
      );

  List<DailyStatsPoint> activityForDays(int days) {
    final n = days.clamp(1, dailyActivity.length);
    return dailyActivity.sublist(dailyActivity.length - n);
  }

  int winsInPeriod(int days) =>
      activityForDays(days).fold(0, (sum, p) => sum + p.wins);

  int activeDaysInPeriod(int days) =>
      activityForDays(days).where((p) => p.wins > 0).length;

  double avgWinsPerDay(int days) {
    final slice = activityForDays(days);
    if (slice.isEmpty) return 0;
    return winsInPeriod(days) / slice.length;
  }

  int? get weekChangePercent {
    if (winsLastWeek == 0) return winsThisWeek > 0 ? 100 : null;
    return ((winsThisWeek - winsLastWeek) / winsLastWeek * 100).round();
  }
}
