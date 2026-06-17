import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/level_unlock_celebration.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/puzzle_difficulty.dart';
import 'puzzle_screen.dart';

/// Celebrates a completed puzzle. Premium dark (Bleu Nuit) ambiance with gold
/// accents, per the brand charte.
class VictoryScreen extends ConsumerStatefulWidget {
  const VictoryScreen({
    super.key,
    required this.session,
    required this.difficulty,
    required this.seconds,
    required this.moves,
    this.unlockedLevel,
  });

  final PuzzleSessionModel session;
  final PuzzleDifficulty difficulty;
  final int seconds;
  final int moves;

  /// When set, a full-screen unlock celebration is shown on top.
  final PuzzleDifficulty? unlockedLevel;

  @override
  ConsumerState<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends ConsumerState<VictoryScreen> {
  late bool _showUnlockCelebration = widget.unlockedLevel != null;

  void _dismissCelebration() => setState(() => _showUnlockCelebration = false);

  void _replay() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(
          session: widget.session,
          difficulty: widget.difficulty,
        ),
      ),
    );
  }

  Future<void> _next() async {
    final sessions = await ref.read(puzzleRepositoryProvider).getSessions();
    if (!context.mounted) return;
    if (sessions.isEmpty) return;
    final others =
        sessions.where((s) => s.id != widget.session.id).toList();
    final pool = others.isEmpty ? sessions : others;
    final next = pool[Random().nextInt(pool.length)];

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(session: next, difficulty: widget.difficulty),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    final unlocked = widget.unlockedLevel;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AuroraBackground(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.file(
                                  File(widget.session.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l.victoryTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.or,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l.victorySubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: tokens.onGlassMuted,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ResultStat(
                                  icon: Icons.timer_outlined,
                                  label: l.statTime,
                                  value: formatDuration(widget.seconds),
                                ),
                                _ResultStat(
                                  icon: Icons.swap_horiz,
                                  label: l.statMoves,
                                  value: '${widget.moves}',
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _VictoryActionButton(
                            icon: Icons.refresh_rounded,
                            label: l.commonReplay,
                            variant: _VictoryButtonVariant.primary,
                            onPressed: _replay,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _VictoryActionButton(
                            icon: Icons.skip_next_rounded,
                            label: l.victoryNext,
                            variant: _VictoryButtonVariant.secondary,
                            onPressed: _next,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _VictoryActionButton(
                            icon: Icons.home_rounded,
                            label: l.victoryHome,
                            variant: _VictoryButtonVariant.outline,
                            onPressed: _goHome,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
          if (_showUnlockCelebration && unlocked != null)
            LevelUnlockCelebration(
              unlocked: unlocked,
              onDismiss: _dismissCelebration,
            ),
        ],
      ),
    );
  }
}

enum _VictoryButtonVariant { primary, secondary, outline }

class _VictoryActionButton extends StatelessWidget {
  const _VictoryActionButton({
    required this.icon,
    required this.label,
    required this.variant,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final _VictoryButtonVariant variant;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    final isPrimary = variant == _VictoryButtonVariant.primary;
    final isSecondary = variant == _VictoryButtonVariant.secondary;

    final gradient = isPrimary
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.orClair, AppColors.or],
          )
        : isSecondary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF3FA9F5).withValues(alpha: 0.85),
                  const Color(0xFF1A6FB5).withValues(alpha: 0.95),
                ],
              )
            : null;

    final fg = isPrimary
        ? AppColors.encre
        : isSecondary
            ? Colors.white
            : AppColors.or;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 72,
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null
                ? tokens.glassSurface
                : null,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPrimary
                  ? AppColors.or.withValues(alpha: 0.6)
                  : isSecondary
                      ? const Color(0xFF3FA9F5).withValues(alpha: 0.5)
                      : AppColors.or.withValues(alpha: 0.45),
              width: isPrimary ? 1.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: (isPrimary
                        ? AppColors.or
                        : isSecondary
                            ? const Color(0xFF3FA9F5)
                            : Colors.black)
                    .withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fg, size: 24),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: fg,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Column(
      children: [
        Icon(icon, color: AppColors.or, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: tokens.onGlass,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: tokens.onGlassMuted, fontSize: 12),
        ),
      ],
    );
  }
}
