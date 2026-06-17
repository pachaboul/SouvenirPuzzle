import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../data/models/puzzle_stats.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';

/// Aggregate statistics page (aurora/glass).
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  static String _time(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static String _totalTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final statsFuture = ref.watch(puzzleRepositoryProvider).getStats();
    return AuroraPage(
      title: l.statsTitle,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: FutureBuilder<PuzzleStats>(
        future: statsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.or),
            );
          }
          final stats = snapshot.data!;
          return ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.photo_library_outlined,
                      accent: const Color(0xFF3FA9F5),
                      value: '${stats.totalMemories}',
                      label: l.statsMemories,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_events_outlined,
                      accent: AppColors.or,
                      value: '${stats.totalCompleted}',
                      label: l.statsCompleted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer_outlined,
                      accent: AppColors.vert,
                      value: _totalTime(stats.totalTimeSeconds),
                      label: l.statsTotalTime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.swap_horiz,
                      accent: AppColors.violet,
                      value: '${stats.totalMoves}',
                      label: l.statsTotalMoves,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                child: Text(
                  l.statsByLevel.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.or,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                borderRadius: 18,
                child: Column(
                  children: [
                    for (final difficulty in PuzzleDifficulty.values)
                      _LevelRow(
                        difficulty: difficulty,
                        wins: stats.winsByDifficulty[difficulty] ?? 0,
                        bestTime: stats.bestTimeByDifficulty[difficulty],
                        bestLabel: l.statsBest,
                      ),
                  ],
                ),
              ),
              if (!stats.hasPlayed)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    l.statsNoData,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.accent,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color accent;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 26),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.difficulty,
    required this.wins,
    required this.bestTime,
    required this.bestLabel,
  });

  final PuzzleDifficulty difficulty;
  final int wins;
  final int? bestTime;
  final String bestLabel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final accent = AppColors.difficulty(difficulty);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              difficulty.label(l),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$wins 🏆',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(width: 16),
          Text(
            bestTime == null ? '—' : '$bestLabel ${StatsScreen._time(bestTime!)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
