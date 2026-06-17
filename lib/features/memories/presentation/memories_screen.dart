import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/aurora_background.dart';
import '../../../core/widgets/aurora_page.dart';
import '../../../core/widgets/aurora_tokens.dart';
import '../../../core/widgets/compact_layout.dart';
import '../../../core/widgets/profile_avatar_button.dart';
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
  const MemoriesScreen({super.key, this.onMenu, this.onProfile});

  /// Opens the app drawer when hosted in the shell.
  final VoidCallback? onMenu;
  final VoidCallback? onProfile;

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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
      backgroundColor: Theme.of(context).colorScheme.surface,
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
    final compact = CompactLayout.of(context);
    return AuroraPage(
      title: _sessions.isEmpty
          ? l.memoriesTitle
          : l.memoriesCountTitle(_sessions.length),
      padding: compact
          ? const EdgeInsets.fromLTRB(12, 4, 12, 0)
          : const EdgeInsets.fromLTRB(16, 8, 16, 0),
      leading: widget.onMenu == null
          ? null
          : IconButton(
              icon: const Icon(Icons.menu),
              tooltip: l.menu,
              onPressed: widget.onMenu,
            ),
      actions: [
        if (widget.onProfile != null)
          ProfileAvatarButton(onTap: widget.onProfile!),
        IconButton(
          icon: const Icon(Icons.add_a_photo_outlined),
          tooltip: l.memoriesAdd,
          onPressed: _busy ? null : _addPhotos,
        ),
      ],
      floatingActionButton: _sessions.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _busy ? null : _playRandom,
              icon: const Icon(Icons.shuffle),
              label: Text(l.memoriesPlay),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_busy)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(color: AppColors.or),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.or),
      );
    }
    if (_sessions.isEmpty) {
      return _EmptyState(onAdd: _busy ? null : _addPhotos);
    }
    return Column(
      children: [
        _ProgressionHeader(wins: _wins),
        const SizedBox(height: 10),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 3 thumbnails per row on phones; 4 on wider screens.
              final crossAxisCount = constraints.maxWidth >= 520 ? 4 : 3;
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _sessions.length,
                itemBuilder: (context, index) {
                  final session = _sessions[index];
                  return _MemoryTile(
                    session: session,
                    onTap: () => _showDetails(session),
                  );
                },
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
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: 16,
      child: SizedBox(
        height: 64,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: PuzzleDifficulty.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final difficulty = PuzzleDifficulty.values[index];
            return SizedBox(
              width: 72,
              child: _LevelChip(
                difficulty: difficulty,
                wins: wins[difficulty] ?? 0,
                unlocked: LevelProgression.isUnlocked(difficulty, wins),
              ),
            );
          },
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
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    final accent = AppColors.difficulty(difficulty);
    final progress =
        (min(wins, LevelProgression.matchesPerLevel) /
                LevelProgression.matchesPerLevel)
            .clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            difficulty.label(l),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unlocked ? accent : tokens.onGlassMuted,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          if (unlocked) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                color: accent,
                backgroundColor: tokens.divider,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$wins/${LevelProgression.matchesPerLevel}',
              style: TextStyle(color: tokens.onGlassMuted, fontSize: 9),
            ),
          ] else
            Icon(Icons.lock_outline, size: 14, color: tokens.onGlassMuted),
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
    final tokens = AuroraTokens.of(context);
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: tokens.glassBorder),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasThumb)
                Image.file(
                  File(thumbPath),
                  fit: BoxFit.cover,
                  cacheWidth: 240,
                )
              else
                ColoredBox(
                  color: AppColors.bleuSecondaire,
                  child: Icon(
                    Icons.image_outlined,
                    color: tokens.onGlassSubtle,
                    size: 28,
                  ),
                ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                    stops: [0.55, 1],
                  ),
                ),
              ),
              Positioned(
                left: 6,
                right: 6,
                bottom: 5,
                child: _TileCaption(session: session),
              ),
            ],
          ),
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
        children: [Icon(Icons.fiber_new, color: AppColors.or, size: 14)],
      );
    }
    return Row(
      children: [
        const Icon(Icons.timer_outlined, color: Colors.white, size: 11),
        const SizedBox(width: 2),
        Text(
          _formatSeconds(session.bestTimeSeconds!),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.play_arrow,
          color: Colors.white.withValues(alpha: 0.9),
          size: 12,
        ),
        Text(
          '${session.playCount}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
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
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: File(imagePath).existsSync()
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        cacheWidth: 480,
                      )
                    : const ColoredBox(color: AppColors.bleuSecondaire),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final difficulty in PuzzleDifficulty.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _BestPerLevel(
                        difficulty: difficulty,
                        best: bests[difficulty],
                      ),
                    ),
                ],
              ),
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
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.difficulty(difficulty),
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
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
    final tokens = AuroraTokens.of(context);
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
              style: TextStyle(
                color: tokens.onGlass,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l.memoriesEmptyBody,
              style: TextStyle(color: tokens.onGlassMuted),
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
