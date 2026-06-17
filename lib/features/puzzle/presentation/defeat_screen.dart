import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/puzzle_difficulty.dart';
import 'puzzle_screen.dart';

/// Shown when the countdown timer reaches zero before the puzzle is solved.
class DefeatScreen extends StatelessWidget {
  const DefeatScreen({
    super.key,
    required this.session,
    required this.difficulty,
    required this.seconds,
    required this.moves,
  });

  final PuzzleSessionModel session;
  final PuzzleDifficulty difficulty;
  final int seconds;
  final int moves;

  void _replay(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(
          session: session,
          difficulty: difficulty,
        ),
      ),
    );
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    return Scaffold(
      body: AuroraBackground(
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
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.3, 0, 0, 0, 0,
                              0, 0.3, 0, 0, 0,
                              0, 0, 0.3, 0, 0,
                              0, 0, 0, 1, 0,
                            ]),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.file(
                                File(session.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l.defeatTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.defeatSubtitle,
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
                              value: formatDuration(seconds),
                            ),
                            _ResultStat(
                              icon: Icons.swap_horiz,
                              label: l.statMoves,
                              value: '$moves',
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
                      child: _DefeatActionButton(
                        icon: Icons.refresh_rounded,
                        label: l.commonReplay,
                        primary: true,
                        onPressed: () => _replay(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DefeatActionButton(
                        icon: Icons.home_rounded,
                        label: l.victoryHome,
                        primary: false,
                        onPressed: () => _goHome(context),
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
    );
  }
}

class _DefeatActionButton extends StatelessWidget {
  const _DefeatActionButton({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 72,
          decoration: BoxDecoration(
            gradient: primary
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.orClair, AppColors.or],
                  )
                : null,
            color: primary ? null : tokens.glassSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary
                  ? AppColors.or.withValues(alpha: 0.6)
                  : AppColors.or.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary ? AppColors.encre : AppColors.or,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primary ? AppColors.encre : AppColors.or,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
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
