import 'package:souvenir_puzzle/data/models/puzzle_session_model.dart';
import 'package:souvenir_puzzle/data/models/puzzle_stats.dart';
import 'package:souvenir_puzzle/data/models/user_profile.dart';
import 'package:souvenir_puzzle/data/repositories/profile_repository.dart';
import 'package:souvenir_puzzle/features/home/home_providers.dart';
import 'package:souvenir_puzzle/features/puzzle/domain/puzzle_difficulty.dart';

/// Demo data for marketing / store screenshots.
abstract final class ScreenshotDemoData {
  static final profile = UserProfile(
    id: ProfileIds.legacyDefault,
    name: 'Marie',
    createdAt: DateTime(2025, 6, 1),
  );

  static final profileState = ProfileState(
    profiles: [profile],
    activeProfileId: ProfileIds.legacyDefault,
  );

  static PuzzleSessionModel memorySession(String imagePath, {String? thumb}) {
    return PuzzleSessionModel(
      id: 'demo-memory-1',
      profileId: ProfileIds.legacyDefault,
      originalImageReference: null,
      imagePath: imagePath,
      thumbnailPath: thumb ?? imagePath,
      difficulty: PuzzleDifficulty.medium.name,
      rows: 4,
      columns: 4,
      createdAt: DateTime(2025, 6, 10, 14, 30),
      lastPlayedAt: DateTime(2025, 6, 16, 18, 45),
      isCompleted: false,
      bestTimeSeconds: 142,
      bestMoves: 38,
      playCount: 3,
    );
  }

  static List<PuzzleSessionModel> memorySessions(String imagePath) => [
        memorySession(imagePath),
        PuzzleSessionModel(
          id: 'demo-memory-2',
          profileId: ProfileIds.legacyDefault,
          originalImageReference: null,
          imagePath: imagePath,
          thumbnailPath: imagePath,
          difficulty: PuzzleDifficulty.easy.name,
          rows: 3,
          columns: 3,
          createdAt: DateTime(2025, 6, 8),
          lastPlayedAt: DateTime(2025, 6, 15),
          isCompleted: true,
          bestTimeSeconds: 95,
          bestMoves: 22,
          playCount: 5,
        ),
        PuzzleSessionModel(
          id: 'demo-memory-3',
          profileId: ProfileIds.legacyDefault,
          originalImageReference: null,
          imagePath: imagePath,
          thumbnailPath: imagePath,
          difficulty: PuzzleDifficulty.hard.name,
          rows: 5,
          columns: 5,
          createdAt: DateTime(2025, 6, 5),
          lastPlayedAt: DateTime(2025, 6, 12),
          isCompleted: true,
          bestTimeSeconds: 310,
          bestMoves: 67,
          playCount: 2,
        ),
      ];

  static final demoWins = {
    for (final d in PuzzleDifficulty.values) d: switch (d) {
      PuzzleDifficulty.easy => 8,
      PuzzleDifficulty.medium => 5,
      PuzzleDifficulty.hard => 2,
      _ => 0,
    },
  };

  static HomeState homeState(String imagePath) => HomeState(
        wins: demoWins,
        lastSession: memorySession(imagePath),
        memoryCount: 3,
      );

  static PuzzleStats stats() {
    final today = DateTime.now();
    final daily = List.generate(30, (i) {
      final wins = [0, 1, 2, 1, 0, 3, 2, 1, 0, 2, 1, 3, 2, 0, 1][i % 15];
      return DailyStatsPoint(
        date: DateTime(today.year, today.month, today.day)
            .subtract(Duration(days: 29 - i)),
        wins: wins,
        avgTimeSeconds: wins > 0 ? 110 + (i * 7) % 90 : null,
      );
    });
    return PuzzleStats(
      totalMemories: 3,
      totalCompleted: 15,
      totalTimeSeconds: 2840,
      totalMoves: 412,
      winsByDifficulty: demoWins,
      bestTimeByDifficulty: {
        for (final d in PuzzleDifficulty.values)
          d: switch (d) {
            PuzzleDifficulty.easy => 72,
            PuzzleDifficulty.medium => 142,
            PuzzleDifficulty.hard => 298,
            _ => null,
          },
      },
      dailyActivity: daily,
      currentStreak: 4,
      bestStreak: 7,
      avgTimeSeconds: 128,
      winsThisWeek: 6,
      winsLastWeek: 4,
      favoriteDifficulty: PuzzleDifficulty.medium,
      peakDay: daily[22],
    );
  }
}
