import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../../puzzle/domain/level_progression.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';

/// Shows the difficulty chooser as a bottom sheet and returns the chosen
/// (unlocked) difficulty, or null if dismissed.
Future<PuzzleDifficulty?> showDifficultyChooser(
  BuildContext context,
  Map<PuzzleDifficulty, int> wins,
) {
  return showModalBottomSheet<PuzzleDifficulty>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    backgroundColor: AppColors.bleuNuit,
    builder: (context) => Theme(
      data: AppTheme.dark(),
      child: _DifficultyChooserSheet(wins: wins),
    ),
  );
}

class _DifficultyChooserSheet extends StatelessWidget {
  const _DifficultyChooserSheet({required this.wins});

  final Map<PuzzleDifficulty, int> wins;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.78,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  AppLocalizations.of(context).difficultyChoose,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              for (final difficulty in PuzzleDifficulty.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DifficultyLevelTile(
                    difficulty: difficulty,
                    wins: wins[difficulty] ?? 0,
                    unlocked: LevelProgression.isUnlocked(difficulty, wins),
                    onTap: () => Navigator.of(context).pop(difficulty),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A level row showing progress toward the next unlock, or a locked state.
/// Shared by the chooser sheet and the create-puzzle screen.
class DifficultyLevelTile extends StatelessWidget {
  const DifficultyLevelTile({
    super.key,
    required this.difficulty,
    required this.wins,
    required this.unlocked,
    required this.onTap,
    this.selected = false,
  });

  final PuzzleDifficulty difficulty;
  final int wins;
  final bool unlocked;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final accent = AppColors.difficulty(difficulty);
    final progress =
        (min(wins, LevelProgression.matchesPerLevel) /
                LevelProgression.matchesPerLevel)
            .clamp(0.0, 1.0);

    final borderColor = unlocked && selected
        ? accent
        : theme.colorScheme.outlineVariant;

    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: selected ? accent.withValues(alpha: 0.12) : null,
        border: Border.all(
          color: borderColor,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            unlocked
                ? (selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked)
                : Icons.lock_outline,
            color: unlocked && selected
                ? accent
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${difficulty.label(l)} · ${difficulty.gridSize}×${difficulty.gridSize}',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                if (unlocked) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.winsProgress(wins, LevelProgression.matchesPerLevel),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else
                  Text(
                    _lockHint(l),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!unlocked) {
      return Opacity(opacity: 0.6, child: content);
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }

  String _lockHint(AppLocalizations l) {
    final required = LevelProgression.prerequisite(difficulty);
    if (required == null) return l.locked;
    return l.lockHint(LevelProgression.winsToUnlock, required.label(l));
  }
}
