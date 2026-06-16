import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../difficulty/presentation/difficulty_chooser.dart';
import '../domain/puzzle_difficulty.dart';
import 'puzzle_screen.dart';

/// Celebrates a completed puzzle. Premium dark (Bleu Nuit) ambiance with gold
/// accents, per the brand charte.
class VictoryScreen extends ConsumerWidget {
  const VictoryScreen({
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
        builder: (_) => PuzzleScreen(session: session, difficulty: difficulty),
      ),
    );
  }

  /// Picks another random memory and plays it (difficulty chosen at play time).
  Future<void> _next(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(puzzleRepositoryProvider);
    final sessions = await repo.getSessions();
    if (sessions.isEmpty) return;
    final others = sessions.where((s) => s.id != session.id).toList();
    final pool = others.isEmpty ? sessions : others;
    final next = pool[Random().nextInt(pool.length)];

    final wins = await repo.winsByDifficulty();
    if (!context.mounted) return;
    final chosen = await showDifficultyChooser(context, wins);
    if (chosen == null || !context.mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(session: next, difficulty: chosen),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bleuNuit,
      body: SafeArea(
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
                            File(session.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Félicitations !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.or,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Souvenir complété.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ResultStat(
                            icon: Icons.timer_outlined,
                            label: 'Temps',
                            value: formatDuration(seconds),
                          ),
                          _ResultStat(
                            icon: Icons.swap_horiz,
                            label: 'Mouvements',
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
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.or,
                        foregroundColor: AppColors.encre,
                      ),
                      onPressed: () => _replay(context),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Rejouer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                      ),
                      onPressed: () => _next(context, ref),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Suivant'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Nouveau souvenir'),
              ),
              const SizedBox(height: 8),
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
    return Column(
      children: [
        Icon(icon, color: AppColors.or, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
