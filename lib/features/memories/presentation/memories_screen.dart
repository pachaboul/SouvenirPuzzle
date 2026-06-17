import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../data/models/best_score.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../../difficulty/presentation/difficulty_chooser.dart';
import '../../puzzle/domain/level_progression.dart';
import '../../puzzle/domain/puzzle_difficulty.dart';
import '../../puzzle/presentation/puzzle_screen.dart';

String _formatSeconds(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

/// History of puzzles ("Mes souvenirs"): a photo gallery on an aurora backdrop.
/// Add several photos, play a random one, or open a memory for details.
class MemoriesScreen extends ConsumerStatefulWidget {
  const MemoriesScreen({super.key, this.onMenu});

  /// Opens the app drawer when hosted in the shell.
  final VoidCallback? onMenu;

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
    setState(() => _busy = true);
    try {
      final picked = await _picker.pickMultiImage();
      if (picked.isEmpty) return;

      final repo = ref.read(puzzleRepositoryProvider);
      for (final image in picked) {
        await repo.createSession(
          sourceImage: File(image.path),
          difficulty: PuzzleDifficulty.easy,
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        _snack(AppLocalizations.of(context).memoriesAddError('$e'));
      }
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

  Future<void> _playRandom() async {
    if (_sessions.isEmpty) return;
    final session = _sessions[_random.nextInt(_sessions.length)];
    await _open(session);
  }

  Future<void> _showDetails(PuzzleSessionModel session) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => _DetailsSheet(
        session: session,
        bests: _bests[session.id] ?? const {},
        onPlay: () {
          Navigator.of(context).pop();
          _open(session);
        },
        onDelete: () {
          Navigator.of(context).pop();
          _confirmDelete(session);
        },
      ),
    );
  }

  Future<void> _confirmDelete(PuzzleSessionModel session) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.memoriesDeleteTitle),
        content: Text(l.memoriesDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.commonDelete),
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
    final l = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      floatingActionButton: _sessions.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _busy ? null : _playRandom,
              icon: const Icon(Icons.shuffle),
              label: Text(l.memoriesPlay),
            ),
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  title: _sessions.isEmpty
                      ? l.memoriesTitle
                      : l.memoriesCountTitle(_sessions.length),
                  onMenu: widget.onMenu,
                  onAdd: _busy ? null : _addPhotos,
                  menuTooltip: l.menu,
                  addTooltip: l.memoriesAdd,
                ),
                if (_busy)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: LinearProgressIndicator(color: AppColors.or),
                  ),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.or));
    }
    if (_sessions.isEmpty) {
      return _EmptyState(onAdd: _busy ? null : _addPhotos);
    }
    return Column(
      children: [
        _ProgressionHeader(wins: _wins),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.86,
            ),
            itemCount: _sessions.length,
            itemBuilder: (context, index) {
              final session = _sessions[index];
              return _MemoryTile(
                session: session,
                onTap: () => _showDetails(session),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.onMenu,
    required this.onAdd,
    required this.menuTooltip,
    required this.addTooltip,
  });

  final String title;
  final VoidCallback? onMenu;
  final VoidCallback? onAdd;
  final String menuTooltip;
  final String addTooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          if (onMenu != null)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              tooltip: menuTooltip,
              onPressed: onMenu,
            ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
            tooltip: addTooltip,
            onPressed: onAdd,
          ),
        ],
      ),
    );
  }
}

class _ProgressionHeader extends StatelessWidget {
  const _ProgressionHeader({required this.wins});

  final Map<PuzzleDifficulty, int> wins;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      borderRadius: 20,
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
    final l = AppLocalizations.of(context);
    final accent = AppColors.difficulty(difficulty);
    final progress = (min(wins, LevelProgression.winsPerLevel) /
            LevelProgression.winsPerLevel)
        .clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Text(
            difficulty.label(l),
            style: TextStyle(
              color: unlocked ? accent : Colors.white60,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          if (unlocked) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: accent,
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$wins/${LevelProgression.winsPerLevel}',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.lock_outline, size: 18, color: Colors.white60),
            ),
        ],
      ),
    );
  }
}

class _MemoryTile extends StatelessWidget {
  const _MemoryTile({required this.session, required this.onTap});

  final PuzzleSessionModel session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final thumbPath = session.thumbnailPath;
    final hasThumb = thumbPath != null && File(thumbPath).existsSync();
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasThumb)
              Image.file(File(thumbPath), fit: BoxFit.cover)
            else
              const ColoredBox(
                color: AppColors.bleuSecondaire,
                child: Icon(Icons.image_outlined, color: Colors.white54),
              ),
            // Bottom scrim for legibility.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.5, 1],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 8,
              child: _TileCaption(session: session),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileCaption extends StatelessWidget {
  const _TileCaption({required this.session});

  final PuzzleSessionModel session;

  @override
  Widget build(BuildContext context) {
    if (session.playCount == 0 || session.bestTimeSeconds == null) {
      return const Row(
        children: [
          Icon(Icons.fiber_new, color: AppColors.or, size: 18),
        ],
      );
    }
    return Row(
      children: [
        const Icon(Icons.timer_outlined, color: Colors.white, size: 14),
        const SizedBox(width: 4),
        Text(
          _formatSeconds(session.bestTimeSeconds!),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Icon(Icons.play_arrow, color: Colors.white.withValues(alpha: 0.9), size: 16),
        Text(
          '${session.playCount}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

class _DetailsSheet extends StatelessWidget {
  const _DetailsSheet({
    required this.session,
    required this.bests,
    required this.onPlay,
    required this.onDelete,
  });

  final PuzzleSessionModel session;
  final Map<PuzzleDifficulty, BestScore> bests;
  final VoidCallback onPlay;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final imagePath = session.imagePath;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: File(imagePath).existsSync()
                    ? Image.file(File(imagePath), fit: BoxFit.cover)
                    : const ColoredBox(color: AppColors.bleuSecondaire),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onPlay,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l.memoriesPlay),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.commonDelete),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BestPerLevel extends StatelessWidget {
  const _BestPerLevel({required this.difficulty, required this.best});

  final PuzzleDifficulty difficulty;
  final BestScore? best;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context);
    final value = best == null ? '—' : _formatSeconds(best!.timeSeconds);
    return Column(
      children: [
        Text(
          difficulty.label(l),
          style: theme.textTheme.labelSmall
              ?.copyWith(color: AppColors.difficulty(difficulty)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
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
    final l = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 72,
              color: AppColors.or,
            ),
            const SizedBox(height: 16),
            Text(
              l.memoriesEmptyTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.memoriesEmptyBody,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.or,
                foregroundColor: AppColors.encre,
              ),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: Text(l.memoriesAdd),
            ),
          ],
        ),
      ),
    );
  }
}
