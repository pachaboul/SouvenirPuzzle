import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/profile_avatar_button.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../../puzzle/domain/level_progression.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';
import '../../puzzle/presentation/play_random.dart';
import '../../puzzle/presentation/puzzle_screen.dart';
import '../../photo_picker/presentation/photo_picker_screen.dart';
import '../home_providers.dart';

/// Home tab — aurora backdrop with level progress and primary actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    this.onMenu,
    this.onProfile,
    this.onOpenMemories,
  });

  final VoidCallback? onMenu;
  final VoidCallback? onProfile;
  final VoidCallback? onOpenMemories;

  Future<void> _resumeLastMatch(BuildContext context, WidgetRef ref) async {
    final state = await ref.read(homeStateProvider.future);
    final session = state.lastSession;
    if (session == null || !context.mounted) return;

    final difficulty = PuzzleDifficulty.values.byName(session.difficulty);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(session: session, difficulty: difficulty),
      ),
    );
    ref.invalidate(homeStateProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final homeAsync = ref.watch(homeStateProvider);
    final tokens = AuroraTokens.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: tokens.onGlass,
        elevation: 0,
        leading: onMenu == null
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                tooltip: l.menu,
                onPressed: onMenu,
              ),
        actions: onProfile == null
            ? null
            : [ProfileAvatarButton(onTap: onProfile!)],
      ),
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 4),
                        Image.asset(
                          'assets/images/logo-souvenirpuzzle.png',
                          height: 96,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.extension_outlined,
                            size: 80,
                            color: AppColors.or,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l.appName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tokens.onGlass,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.homeTagline,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tokens.onGlassMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        homeAsync.maybeWhen(
                          data: (state) => state.canResume
                              ? _ResumeButton(
                                  session: state.lastSession!,
                                  label: l.homeResumeLastMatch,
                                  onTap: () => _resumeLastMatch(context, ref),
                                )
                              : const SizedBox.shrink(),
                          orElse: () => const SizedBox.shrink(),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.06,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _GlassAction(
                                  label: l.homeCreatePuzzle,
                                  icon: Icons.add_photo_alternate_outlined,
                                  accent: const Color(0xFF3FA9F5),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const PhotoPickerScreen(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _GlassAction(
                                  label: l.homePlay,
                                  icon: Icons.shuffle,
                                  accent: AppColors.or,
                                  onTap: () async {
                                    await playRandomMemory(
                                      context,
                                      ref,
                                      onEmpty: onOpenMemories,
                                    );
                                    ref.invalidate(homeStateProvider);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        homeAsync.when(
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.or,
                              ),
                            ),
                          ),
                          error: (_, __) => const SizedBox.shrink(),
                          data: (state) => _CurrentLevelCard(state: state),
                        ),
                        const SizedBox(height: 88),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentLevelCard extends StatelessWidget {
  const _CurrentLevelCard({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    final level = state.activeLevel;
    final accent = AppColors.difficulty(level);
    final wins = state.levelWins;
    final next = state.nextLevel;
    final grid = level.gridSize;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accent.withValues(alpha: 0.45)),
                ),
                child: Text(
                  l.homeCurrentLevel.toUpperCase(),
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                l.homeGridSize(grid),
                style: TextStyle(color: tokens.onGlassSubtle, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  level.label(l),
                  style: TextStyle(
                    color: accent,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
              Text(
                l.homeLevelMatches(wins, LevelProgression.matchesPerLevel),
                style: TextStyle(
                  color: tokens.onGlass,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LevelStat(
                  label: l.homeWinsLabel,
                  value: l.homeLevelMatches(
                    wins,
                    LevelProgression.matchesPerLevel,
                  ),
                  progress: state.levelProgressFraction,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LevelStat(
                  label: l.homeUnlockLabel,
                  value: next == null
                      ? l.homeLevelMax
                      : l.homeUnlockNext(
                          wins.clamp(0, LevelProgression.winsToUnlock),
                          LevelProgression.winsToUnlock,
                          next.label(l),
                        ),
                  progress: state.unlockProgressFraction,
                  color: next == null ? AppColors.or : AppColors.difficulty(next),
                  compactValue: next != null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelStat extends StatelessWidget {
  const _LevelStat({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    this.compactValue = false,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tokens.isDark
            ? Colors.black.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: tokens.onGlassSubtle,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: compactValue ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: compactValue ? 12 : 14,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: tokens.divider.withValues(alpha: 0.5),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  const _ResumeButton({
    required this.session,
    required this.label,
    required this.onTap,
  });

  final PuzzleSessionModel session;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final thumbPath = session.thumbnailPath;
    final hasThumb = thumbPath != null && File(thumbPath).existsSync();
    final difficulty = PuzzleDifficulty.values.byName(session.difficulty);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.or.withValues(alpha: 0.85),
                AppColors.orClair.withValues(alpha: 0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.or.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 132,
                  width: double.infinity,
                  child: hasThumb
                      ? Image.file(File(thumbPath), fit: BoxFit.cover)
                      : ColoredBox(
                          color: AppColors.bleuNuit.withValues(alpha: 0.4),
                          child: const Icon(
                            Icons.image_outlined,
                            color: Colors.white70,
                            size: 48,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 14, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.encre,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            difficulty.label(l),
                            style: TextStyle(
                              color: AppColors.encre.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.encre,
                      size: 36,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassAction extends StatelessWidget {
  const _GlassAction({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 28),
          Text(
            label,
            style: TextStyle(
              color: tokens.onGlass,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
