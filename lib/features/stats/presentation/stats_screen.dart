import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/compact_layout.dart';
import '../../../core/widgets/profile_avatar_button.dart';
import '../../../data/models/puzzle_stats.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';
import 'widgets/stats_charts.dart';

/// Dashboard-style statistics page with timeline charts and insights.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key, this.onMenu, this.onProfile});

  final VoidCallback? onMenu;
  final VoidCallback? onProfile;

  static String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static String formatTotalTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _periodDays = 14;
  int? _activitySelected;
  int? _timeSelected;
  bool _showAllLevels = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final statsAsync = ref.watch(statsProvider);
    final compact = CompactLayout.of(context);

    return AuroraPage(
      title: l.statsTitle,
      padding: compact
          ? const EdgeInsets.fromLTRB(12, 4, 12, 12)
          : const EdgeInsets.fromLTRB(16, 8, 16, 24),
      leading: widget.onMenu == null
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              tooltip: l.menu,
              onPressed: widget.onMenu,
            ),
      actions: widget.onProfile == null
          ? null
          : [ProfileAvatarButton(onTap: widget.onProfile!)],
      child: statsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.or),
        ),
        error: (_, __) {
          final tokens = AuroraTokens.of(context);
          return Center(
            child: Text(
              l.statsNoData,
              style: TextStyle(color: tokens.onGlassMuted),
            ),
          );
        },
        data: (stats) {
          if (!stats.hasPlayed) {
            return _EmptyState(message: l.statsNoData);
          }
          return RefreshIndicator(
            color: AppColors.or,
            backgroundColor: AppColors.bleuSecondaire,
            onRefresh: () async => ref.invalidate(statsProvider),
            child: _StatsBody(
              stats: stats,
              periodDays: _periodDays,
              activitySelected: _activitySelected,
              timeSelected: _timeSelected,
              showAllLevels: _showAllLevels,
              onPeriodChanged: (d) => setState(() {
                _periodDays = d;
                _activitySelected = null;
                _timeSelected = null;
              }),
              onActivitySelected: (i) => setState(() => _activitySelected = i),
              onTimeSelected: (i) => setState(() => _timeSelected = i),
              onToggleLevels: () =>
                  setState(() => _showAllLevels = !_showAllLevels),
            ),
          );
        },
      ),
    );
  }
}

class _StatsBody extends StatelessWidget {
  const _StatsBody({
    required this.stats,
    required this.periodDays,
    required this.activitySelected,
    required this.timeSelected,
    required this.showAllLevels,
    required this.onPeriodChanged,
    required this.onActivitySelected,
    required this.onTimeSelected,
    required this.onToggleLevels,
  });

  final PuzzleStats stats;
  final int periodDays;
  final int? activitySelected;
  final int? timeSelected;
  final bool showAllLevels;
  final ValueChanged<int> onPeriodChanged;
  final ValueChanged<int?> onActivitySelected;
  final ValueChanged<int?> onTimeSelected;
  final VoidCallback onToggleLevels;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final activity = stats.activityForDays(periodDays);
    final winsInPeriod = stats.winsInPeriod(periodDays);
    final avgPerDay = stats.avgWinsPerDay(periodDays);

    final levelsWithWins = PuzzleDifficulty.values
        .where((d) => (stats.winsByDifficulty[d] ?? 0) > 0)
        .toList();
    final visibleLevels = showAllLevels
        ? PuzzleDifficulty.values
        : (levelsWithWins.isEmpty
            ? PuzzleDifficulty.values.take(3).toList()
            : levelsWithWins);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: CompactLayout.bottomNavClearance(context)),
      children: [
        _HeroDashboard(stats: stats, l: l, periodDays: periodDays),
        const SizedBox(height: 16),
        _SectionLabel(l.statsInsights),
        const SizedBox(height: 8),
        _InsightsRow(stats: stats, l: l, periodDays: periodDays),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _SectionLabel(l.statsProgression)),
            _PeriodSelector(
              periodDays: periodDays,
              onChanged: onPeriodChanged,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _ChartCard(
          title: _periodLabel(l, periodDays, l.statsActivitySubtitle),
          subtitle: l.statsTapChartHint,
          icon: Icons.show_chart,
          accent: const Color(0xFF3FA9F5),
          footer: _ChartFooter(
            total: l.statsTotalInPeriod(winsInPeriod),
            avg: l.statsAvgPerDay(avgPerDay.toStringAsFixed(1)),
            extra: stats.peakDay != null && stats.peakDay!.wins > 0
                ? '${l.statsPeakDay}: ${DateFormat.E(locale).format(stats.peakDay!.date)} · ${l.statsPeakWins(stats.peakDay!.wins)}'
                : null,
          ),
          child: StatsAreaChart(
            values: activity.map((p) => p.wins.toDouble()).toList(),
            labels: activity.map((p) => DateFormat.E(locale).format(p.date)).toList(),
            lineColor: const Color(0xFF3FA9F5),
            fillColor: const Color(0xFF3FA9F5),
            maxValue: _mathMax(
              activity.fold<double>(0, (m, p) => p.wins > m ? p.wins.toDouble() : m),
              1,
            ),
            selectedIndex: activitySelected,
            onSelectIndex: onActivitySelected,
            valueLabelBuilder: (v) => '${v.toInt()}',
          ),
        ),
        const SizedBox(height: 14),
        _ChartCard(
          title: _periodLabel(l, periodDays, l.statsTimeTrendSubtitle),
          subtitle: l.statsTapChartHint,
          icon: Icons.timeline,
          accent: AppColors.vert,
          child: StatsAreaChart(
            values: activity
                .map((p) => (p.avgTimeSeconds ?? 0) / 60.0)
                .toList(),
            labels: activity.map((p) => DateFormat.E(locale).format(p.date)).toList(),
            lineColor: AppColors.vert,
            fillColor: AppColors.vert,
            maxValue: _maxAvgMinutes(activity),
            selectedIndex: timeSelected,
            onSelectIndex: onTimeSelected,
            valueLabelBuilder: (v) => v > 0 ? '${v.toStringAsFixed(1)} min' : '—',
          ),
        ),
        const SizedBox(height: 20),
        _SectionLabel(l.statsOverview),
        const SizedBox(height: 8),
        _KpiGrid(stats: stats, l: l),
        const SizedBox(height: 20),
        _SectionLabel(l.statsDistribution),
        const SizedBox(height: 8),
        GlassCard(
          padding: const EdgeInsets.all(18),
          borderRadius: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatsDonutChart(
                segments: [
                  for (final d in PuzzleDifficulty.values)
                    if ((stats.winsByDifficulty[d] ?? 0) > 0)
                      StatsDonutSegment(
                        value: stats.winsByDifficulty[d]!,
                        color: AppColors.difficulty(d),
                      ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatsHorizontalBars(
                  height: 8,
                  items: [
                    for (final d in PuzzleDifficulty.values)
                      if ((stats.winsByDifficulty[d] ?? 0) > 0)
                        StatsBarItem(
                          label: d.label(l),
                          value: stats.winsByDifficulty[d] ?? 0,
                          color: AppColors.difficulty(d),
                          subtitle: stats.bestTimeByDifficulty[d] == null
                              ? null
                              : '${l.statsBest} ${StatsScreen.formatTime(stats.bestTimeByDifficulty[d]!)}',
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _SectionLabel(l.statsLevelDetails)),
            if (levelsWithWins.length < PuzzleDifficulty.values.length)
              TextButton(
                onPressed: onToggleLevels,
                child: Text(
                  showAllLevels ? '−' : '+',
                  style: const TextStyle(color: AppColors.or),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 20,
          child: Column(
            children: [
              for (final difficulty in visibleLevels)
                _LevelDetailRow(
                  difficulty: difficulty,
                  wins: stats.winsByDifficulty[difficulty] ?? 0,
                  maxWins: stats.maxDifficultyWins,
                  bestTime: stats.bestTimeByDifficulty[difficulty],
                  bestLabel: l.statsBest,
                ),
            ],
          ),
        ),
      ],
    );
  }

  static String _periodLabel(AppLocalizations l, int days, String subtitle) {
    final prefix = switch (days) {
      7 => l.statsPeriod7,
      30 => l.statsPeriod30,
      _ => l.statsPeriod14,
    };
    return '$subtitle · $prefix';
  }

  static double _mathMax(double a, double b) => a > b ? a : b;

  static double _maxAvgMinutes(List<DailyStatsPoint> activity) {
    final max = activity.fold<double>(0, (m, p) {
      final v = (p.avgTimeSeconds ?? 0) / 60.0;
      return v > m ? v : m;
    });
    return _mathMax(max, 1);
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periodDays,
    required this.onChanged,
  });

  final int periodDays;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PeriodChip(
          label: l.statsPeriod7,
          selected: periodDays == 7,
          onTap: () => onChanged(7),
        ),
        const SizedBox(width: 4),
        _PeriodChip(
          label: l.statsPeriod14,
          selected: periodDays == 14,
          onTap: () => onChanged(14),
        ),
        const SizedBox(width: 4),
        _PeriodChip(
          label: l.statsPeriod30,
          selected: periodDays == 30,
          onTap: () => onChanged(30),
        ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.or.withValues(alpha: 0.25)
                : tokens.surfaceSubtle,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.or : tokens.divider,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.or : tokens.onGlassMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightsRow extends StatelessWidget {
  const _InsightsRow({
    required this.stats,
    required this.l,
    required this.periodDays,
  });

  final PuzzleStats stats;
  final AppLocalizations l;
  final int periodDays;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final change = stats.weekChangePercent;
    final weekLabel = switch (change) {
      null => stats.winsThisWeek > 0 ? l.statsWeekChangeNew : l.statsWeekChangeSame,
      0 => l.statsWeekChangeSame,
      > 0 => l.statsWeekChangeUp(change),
      _ => l.statsWeekChangeDown(change.abs()),
    };
    final weekColor = switch (change) {
      null || 0 => tokens.onGlassMuted,
      > 0 => AppColors.vert,
      _ => AppColors.rouge,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _InsightCard(
            icon: Icons.trending_up,
            color: weekColor,
            label: l.statsThisWeek,
            value: '${stats.winsThisWeek}',
            caption: weekLabel,
          ),
          const SizedBox(width: 10),
          _InsightCard(
            icon: Icons.local_fire_department,
            color: const Color(0xFFFF8A50),
            label: l.statsBestStreak,
            value: l.statsStreakDays(stats.bestStreak),
            caption: l.statsStreakDays(stats.currentStreak),
          ),
          const SizedBox(width: 10),
          if (stats.favoriteDifficulty != null)
            _InsightCard(
              icon: Icons.star_outline,
              color: AppColors.difficulty(stats.favoriteDifficulty!),
              label: l.statsFavoriteLevel,
              value: stats.favoriteDifficulty!.label(l),
              caption: '${stats.winsByDifficulty[stats.favoriteDifficulty!]} 🏆',
            ),
          const SizedBox(width: 10),
          _InsightCard(
            icon: Icons.calendar_today_outlined,
            color: const Color(0xFF3FA9F5),
            label: l.statsActiveDays,
            value: '${stats.activeDaysInPeriod(periodDays)}',
            caption: l.statsAvgPerDay(
              stats.avgWinsPerDay(periodDays).toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return SizedBox(
      width: 148,
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: tokens.onGlassSubtle, fontSize: 10),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: tokens.onGlass,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color.withValues(alpha: 0.85), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartFooter extends StatelessWidget {
  const _ChartFooter({
    required this.total,
    required this.avg,
    this.extra,
  });

  final String total;
  final String avg;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          _FooterChip(text: total),
          _FooterChip(text: avg),
          if (extra != null) _FooterChip(text: extra!, accent: AppColors.or),
        ],
      ),
    );
  }
}

class _FooterChip extends StatelessWidget {
  const _FooterChip({required this.text, this.accent});

  final String text;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accent?.withValues(alpha: 0.08) ?? tokens.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent?.withValues(alpha: 0.15) ?? tokens.divider,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: accent ?? tokens.onGlassMuted,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        borderRadius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insights_outlined,
              size: 48,
              color: AppColors.or.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: tokens.onGlassMuted, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroDashboard extends StatelessWidget {
  const _HeroDashboard({
    required this.stats,
    required this.l,
    required this.periodDays,
  });

  final PuzzleStats stats;
  final AppLocalizations l;
  final int periodDays;

  @override
  Widget build(BuildContext context) {
    final regularity = stats.activeDaysInPeriod(periodDays) / periodDays;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.or.withValues(alpha: 0.4),
              AppColors.violet.withValues(alpha: 0.25),
              AppColors.bleuNuit.withValues(alpha: 0.95),
            ],
          ),
          border: Border.all(color: AppColors.or.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: AppColors.or.withValues(alpha: 0.22),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.auto_graph,
                size: 120,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.statsCompleted.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        StatsAnimatedCount(
                          value: stats.totalCompleted,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _HeroChip(
                              icon: Icons.local_fire_department,
                              label: l.statsStreak,
                              value: l.statsStreakDays(stats.currentStreak),
                              color: const Color(0xFFFF8A50),
                            ),
                            if (stats.avgTimeSeconds != null)
                              _HeroChip(
                                icon: Icons.timer_outlined,
                                label: l.statsAvgSolve,
                                value: StatsScreen.formatTime(stats.avgTimeSeconds!),
                                color: AppColors.vert,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      StatsRingGauge(
                        progress: regularity,
                        color: AppColors.or,
                        size: 76,
                        strokeWidth: 6,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(regularity * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.statsRegularity,
                        style: const TextStyle(color: Colors.white54, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 9),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.stats, required this.l});

  final PuzzleStats stats;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.photo_library_outlined,
                gradient: [const Color(0xFF3FA9F5), const Color(0xFF1A6FB5)],
                value: '${stats.totalMemories}',
                label: l.statsMemories,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                icon: Icons.emoji_events_outlined,
                gradient: [AppColors.or, AppColors.orClair],
                value: '${stats.totalCompleted}',
                label: l.statsCompleted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                icon: Icons.timer_outlined,
                gradient: [AppColors.vert, const Color(0xFF4A8F6A)],
                value: StatsScreen.formatTotalTime(stats.totalTimeSeconds),
                label: l.statsTotalTime,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiCard(
                icon: Icons.swap_horiz,
                gradient: [AppColors.violet, const Color(0xFF6B4FA8)],
                value: '${stats.totalMoves}',
                label: l.statsTotalMoves,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.gradient,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final List<Color> gradient;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 18,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.35),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: tokens.onGlass,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: tokens.onGlassMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.child,
    this.footer,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: tokens.onGlass,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: tokens.onGlassSubtle, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.or,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _LevelDetailRow extends StatelessWidget {
  const _LevelDetailRow({
    required this.difficulty,
    required this.wins,
    required this.maxWins,
    required this.bestTime,
    required this.bestLabel,
  });

  final PuzzleDifficulty difficulty;
  final int wins;
  final int maxWins;
  final int? bestTime;
  final String bestLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final l = AppLocalizations.of(context);
    final accent = AppColors.difficulty(difficulty);
    final fraction = maxWins > 0 ? wins / maxWins : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: accent.withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${difficulty.gridSize}×',
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        difficulty.label(l),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: tokens.onGlass,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '$wins',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, t, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: t,
                      minHeight: 4,
                      backgroundColor: tokens.surfaceElevated,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bestTime == null
                      ? '—'
                      : '$bestLabel ${StatsScreen.formatTime(bestTime!)}',
                  style: TextStyle(color: tokens.onGlassSubtle, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
