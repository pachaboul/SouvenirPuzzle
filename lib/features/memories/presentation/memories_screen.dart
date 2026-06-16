import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme.dart';
import '../../../data/models/best_score.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../difficulty/presentation/difficulty_chooser.dart';
import '../../puzzle/domain/level_progression.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';
import '../../puzzle/presentation/puzzle_screen.dart';

/// History of puzzles ("Mes souvenirs"): add several photos at once, play a
/// random one (difficulty chosen at play time), or replay / delete a memory.
class MemoriesScreen extends ConsumerStatefulWidget {
  const MemoriesScreen({super.key});

  /// Maximum number of memories kept in the collection.
  static const int maxPhotos = 12;

  @override
  ConsumerState<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends ConsumerState<MemoriesScreen> {
  final ImagePicker _picker = ImagePicker();
  final Random _random = Random();

  List<PuzzleSessionModel> _sessions = [];
  Map<PuzzleDifficulty, int> _wins = {};
  Map<String, Map<PuzzleDifficulty, BestScore>> _bests = {};
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(puzzleRepositoryProvider);
    final sessions = await repo.getSessions();
    final wins = await repo.winsByDifficulty();
    final bests = await repo.bestScoresBySession();
    if (!mounted) return;
    setState(() {
      _sessions = sessions;
      _wins = wins;
      _bests = bests;
      _loading = false;
    });
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addPhotos() async {
    final remaining = MemoriesScreen.maxPhotos - _sessions.length;
    if (remaining <= 0) {
      _snack('Limite de ${MemoriesScreen.maxPhotos} photos atteinte.');
      return;
    }

    setState(() => _busy = true);
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;

      final toAdd = picked.take(remaining).toList();
      final repo = ref.read(puzzleRepositoryProvider);
      for (final image in toAdd) {
        await repo.createSession(
          sourceImage: File(image.path),
          difficulty: PuzzleDifficulty.easy,
        );
      }

      if (picked.length > remaining) {
        _snack(
          '$remaining photo(s) ajoutée(s) — limite de '
          '${MemoriesScreen.maxPhotos} atteinte.',
        );
      }
      await _load();
    } catch (e) {
      _snack('Impossible d\'ajouter les photos : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Asks for a difficulty (locked levels disabled), then plays [session].
  Future<void> _open(PuzzleSessionModel session) async {
    final difficulty = await showDifficultyChooser(context, _wins);
    if (difficulty == null || !mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PuzzleScreen(session: session, difficulty: difficulty),
      ),
    );
    await _load();
  }

  /// Picks a random memory and starts playing it.
  Future<void> _playRandom() async {
    if (_sessions.isEmpty) return;
    final session = _sessions[_random.nextInt(_sessions.length)];
    await _open(session);
  }

  Future<void> _confirmDelete(PuzzleSessionModel session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce souvenir ?'),
        content: const Text(
          'Le puzzle et sa miniature seront supprimés. '
          'Votre photo d\'origine n\'est pas touchée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(puzzleRepositoryProvider).deleteSession(session);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isFull = _sessions.length >= MemoriesScreen.maxPhotos;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _sessions.isEmpty
              ? 'Mes souvenirs'
              : 'Mes souvenirs (${_sessions.length}/${MemoriesScreen.maxPhotos})',
        ),
        actions: [
          IconButton(
            onPressed: (_busy || isFull) ? null : _addPhotos,
            icon: const Icon(Icons.add_a_photo_outlined),
            tooltip: 'Ajouter des photos',
          ),
        ],
      ),
      floatingActionButton: _sessions.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _busy ? null : _playRandom,
              icon: const Icon(Icons.shuffle),
              label: const Text('Jouer'),
            ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_sessions.isEmpty) {
      return _EmptyState(onAdd: _busy ? null : _addPhotos);
    }
    return Column(
      children: [
        if (_busy) const LinearProgressIndicator(),
        _ProgressionHeader(wins: _wins),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            itemCount: _sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final session = _sessions[index];
              return _MemoryCard(
                session: session,
                bests: _bests[session.id] ?? const {},
                onPlay: () => _open(session),
                onDelete: () => _confirmDelete(session),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProgressionHeader extends StatelessWidget {
  const _ProgressionHeader({required this.wins});

  final Map<PuzzleDifficulty, int> wins;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              for (final difficulty in PuzzleDifficulty.values)
                Expanded(
                  child: _LevelChip(
                    difficulty: difficulty,
                    wins: wins[difficulty] ?? 0,
                    unlocked: LevelProgression.isUnlocked(difficulty, wins),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({
    required this.difficulty,
    required this.wins,
    required this.unlocked,
  });

  final PuzzleDifficulty difficulty;
  final int wins;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = AppColors.difficulty(difficulty);
    final progress = (min(wins, LevelProgression.winsPerLevel) /
            LevelProgression.winsPerLevel)
        .clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            difficulty.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: unlocked ? accent : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
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
              '$wins/${LevelProgression.winsPerLevel}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.lock_outline,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

String _formatSeconds(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({
    required this.session,
    required this.bests,
    required this.onPlay,
    required this.onDelete,
  });

  final PuzzleSessionModel session;
  final Map<PuzzleDifficulty, BestScore> bests;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  String get _title => session.playCount > 0
      ? 'Joué ${session.playCount} fois'
      : 'Photo prête à jouer';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbPath = session.thumbnailPath;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPlay,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: thumbPath != null && File(thumbPath).existsSync()
                          ? Image.file(File(thumbPath), fit: BoxFit.cover)
                          : ColoredBox(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.image_outlined,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow),
                    tooltip: 'Jouer',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Supprimer',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final difficulty in PuzzleDifficulty.values)
                    Expanded(
                      child: _BestPerLevel(
                        difficulty: difficulty,
                        best: bests[difficulty],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact best-time badge for one level on a memory card.
class _BestPerLevel extends StatelessWidget {
  const _BestPerLevel({required this.difficulty, required this.best});

  final PuzzleDifficulty difficulty;
  final BestScore? best;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = best == null ? '—' : _formatSeconds(best!.timeSeconds);
    return Column(
      children: [
        Text(
          difficulty.label,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: AppColors.difficulty(difficulty)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: best == null
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun souvenir pour l\'instant',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez jusqu\'à ${MemoriesScreen.maxPhotos} photos, '
              'puis touchez « Jouer » pour un puzzle au hasard.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Ajouter des photos'),
            ),
          ],
        ),
      ),
    );
  }
}
