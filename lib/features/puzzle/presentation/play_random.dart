import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../difficulty/presentation/difficulty_chooser.dart';
import 'puzzle_screen.dart';

/// Picks a random memory, asks for a difficulty, then opens the puzzle.
///
/// If there are no memories yet, shows a hint and calls [onEmpty] (e.g. to
/// switch to the memories tab).
Future<void> playRandomMemory(
  BuildContext context,
  WidgetRef ref, {
  VoidCallback? onEmpty,
}) async {
  final l = AppLocalizations.of(context);
  final repo = ref.read(puzzleRepositoryProvider);
  final sessions = await repo.getSessions();
  if (!context.mounted) return;

  if (sessions.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.playNeedsPhotos)),
    );
    onEmpty?.call();
    return;
  }

  final session = sessions[Random().nextInt(sessions.length)];
  final wins = await repo.winsByDifficulty();
  if (!context.mounted) return;

  final difficulty = await showDifficultyChooser(context, wins);
  if (difficulty == null || !context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => PuzzleScreen(session: session, difficulty: difficulty),
    ),
  );
}
