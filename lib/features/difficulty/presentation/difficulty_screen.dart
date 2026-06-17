import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
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
        SnackBar(content: Text(AppLocalizations.of(context).createError('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    return AuroraPage(
      title: l.difficultyTitle,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(18),
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
                          const SizedBox(height: 20),
                          Text(
                            l.difficultyChoose,
                            style: TextStyle(
                              color: tokens.onGlass,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (final difficulty in PuzzleDifficulty.values)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: DifficultyLevelTile(
                                difficulty: difficulty,
                                wins: _wins[difficulty] ?? 0,
                                unlocked:
                                    LevelProgression.isUnlocked(difficulty, _wins),
                                selected: _selected == difficulty,
                                onTap: _creating
                                    ? () {}
                                    : () => setState(() => _selected = difficulty),
                              ),
                            ),
                        ],
                      ),
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
                      : Text(l.commonStart),
                ),
              ],
            ),
    );
  }
}
