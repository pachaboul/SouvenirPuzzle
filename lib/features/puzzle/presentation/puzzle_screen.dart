import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_constants.dart';
import '../../../app/theme.dart';
import '../../../core/services/feedback_service.dart';
import '../../../data/models/app_settings.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../../../data/repositories/settings_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/l10n_difficulty.dart';
import '../domain/level_progression.dart';
import '../domain/puzzle_difficulty.dart';
import '../domain/puzzle_game.dart';
import 'defeat_screen.dart';
import 'puzzle_board.dart';
import 'victory_screen.dart';

String formatDuration(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

/// The gameplay screen: loads the image, runs the timer, and hosts the board.
class PuzzleScreen extends ConsumerStatefulWidget {
  const PuzzleScreen({
    super.key,
    required this.session,
    required this.difficulty,
  });

  final PuzzleSessionModel session;
  final PuzzleDifficulty difficulty;

  @override
  ConsumerState<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends ConsumerState<PuzzleScreen> {
  PuzzleDifficulty get _difficulty => widget.difficulty;
  late final PuzzleGame _game = PuzzleGame(_difficulty);
  late final Future<ui.Image> _imageFuture =
      _loadImage(File(widget.session.imagePath));
  ui.Image? _decoded;
  Timer? _timer;
  int _elapsed = 0;
  late int _remaining = _difficulty.timeLimitSeconds;
  bool _paused = false;
  bool _finished = false;

  Future<ui.Image> _loadImage(File file) async {
    final bytes = await file.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: AppConstants.maxImageDecodeWidth,
    );
    final frame = await codec.getNextFrame();
    _decoded = frame.image;
    _startTimer();
    return frame.image;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused || !mounted || _finished) return;
      if (_remaining <= 1) {
        setState(() {
          _elapsed++;
          _remaining = 0;
        });
        _onTimeUp();
        return;
      }
      setState(() {
        _elapsed++;
        _remaining--;
      });
    });
  }

  FeedbackService get _feedback {
    final settings =
        ref.read(settingsControllerProvider).asData?.value ??
            const AppSettings();
    return FeedbackService(
      soundEnabled: settings.soundEnabled,
      vibrationEnabled: settings.vibrationEnabled,
    );
  }

  void _onSwap(int a, int b) {
    setState(() => _game.swap(a, b));
    if (_game.isSolved) {
      _feedback.victory();
      _onSolved();
    } else {
      _feedback.pieceMoved();
    }
  }

  Future<void> _onSolved() async {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();

    final seconds = _elapsed;
    final moves = _game.moves;
    final repo = ref.read(puzzleRepositoryProvider);
    final winsBefore = await repo.winsByDifficulty();
    final winsBeforeAtLevel = winsBefore[_difficulty] ?? 0;

    await repo.recordResult(
          session: widget.session,
          difficulty: widget.difficulty,
          seconds: seconds,
          moves: moves,
        );

    final unlockedLevel = LevelProgression.levelUnlockedByWin(
      completedAt: _difficulty,
      winsBeforeAtLevel: winsBeforeAtLevel,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => VictoryScreen(
          session: widget.session,
          difficulty: widget.difficulty,
          seconds: seconds,
          moves: moves,
          unlockedLevel: unlockedLevel,
        ),
      ),
    );
  }

  void _onTimeUp() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    _feedback.defeat();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DefeatScreen(
          session: widget.session,
          difficulty: widget.difficulty,
          seconds: _elapsed,
          moves: _game.moves,
        ),
      ),
    );
  }

  void _togglePause() => setState(() => _paused = !_paused);

  void _restart() {
    setState(() {
      _game.reset();
      _elapsed = 0;
      _remaining = _difficulty.timeLimitSeconds;
      _paused = false;
      _finished = false;
    });
    _startTimer();
  }

  void _showPreview() {
    final l = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: InteractiveViewer(
                child: Image.file(
                  File(widget.session.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.commonClose),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _decoded?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bleuNuit,
      appBar: AppBar(
        backgroundColor: AppColors.bleuNuit,
        foregroundColor: AppColors.cremeDoux,
        title: Text(_difficulty.label(l)),
        actions: [
          IconButton(
            onPressed: _showPreview,
            icon: const Icon(Icons.image_outlined),
            tooltip: l.puzzlePreview,
          ),
          IconButton(
            onPressed: _togglePause,
            icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
            tooltip: _paused ? l.puzzleResume : l.puzzlePause,
          ),
          IconButton(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            tooltip: l.puzzleRestart,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<ui.Image>(
          future: _imageFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.or),
              );
            }
            final image = snapshot.data;
            if (snapshot.hasError || image == null) {
              return Center(
                child: Text(
                  l.puzzleImageError,
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(
                        icon: Icons.timer_outlined,
                        value: formatDuration(_remaining),
                        warning: _remaining <= 30,
                      ),
                      _Stat(icon: Icons.swap_horiz, value: '${_game.moves}'),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            PuzzleBoard(
                              image: image,
                              game: _game,
                              onSwap: _paused ? null : _onSwap,
                            ),
                            if (_paused)
                              _PauseOverlay(onResume: _togglePause),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    this.warning = false,
  });

  final IconData icon;
  final String value;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final accent = warning ? const Color(0xFFFF6B6B) : AppColors.or;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: accent),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: warning ? const Color(0xFFFF6B6B) : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({required this.onResume});

  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.puzzlePaused,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow),
              label: Text(l.puzzleResume),
            ),
          ],
        ),
      ),
    );
  }
}
