import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/puzzle_providers.dart';
import '../../puzzle/domain/level_progression.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';
import '../../puzzle/presentation/puzzle_screen.dart';
import 'difficulty_chooser.dart';

/// Create-puzzle flow: pick a difficulty, then create and play the memory.
class DifficultyScreen extends ConsumerStatefulWidget {
  const DifficultyScreen({super.key, required this.image});

  final File image;

  @override
  ConsumerState<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends ConsumerState<DifficultyScreen> {
  PuzzleDifficulty _selected = PuzzleDifficulty.easy;
  Map<PuzzleDifficulty, int> _wins = {};
  bool _loading = true;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _loadWins();
  }

  Future<void> _loadWins() async {
    final wins = await ref.read(puzzleRepositoryProvider).winsByDifficulty();
    if (!mounted) return;
    setState(() {
      _wins = wins;
      _loading = false;
    });
  }

  Future<void> _start() async {
    setState(() => _creating = true);
    try {
      final session = await ref.read(puzzleRepositoryProvider).createSession(
            sourceImage: widget.image,
            difficulty: _selected,
          );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PuzzleScreen(
            session: session,
            difficulty: _selected,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _creating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de créer le puzzle : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Difficulté')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.file(
                                  widget.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Choisissez un niveau',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            for (final difficulty in PuzzleDifficulty.values)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: DifficultyLevelTile(
                                  difficulty: difficulty,
                                  wins: _wins[difficulty] ?? 0,
                                  unlocked: LevelProgression.isUnlocked(
                                    difficulty,
                                    _wins,
                                  ),
                                  selected: _selected == difficulty,
                                  onTap: _creating
                                      ? () {}
                                      : () => setState(
                                            () => _selected = difficulty,
                                          ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _creating ? null : _start,
                      child: _creating
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Commencer'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
