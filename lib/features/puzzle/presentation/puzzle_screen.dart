import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_constants.dart';
import '../../../app/theme.dart';
import '../../../data/models/puzzle_session_model.dart';
import '../../../data/repositories/puzzle_providers.dart';
import '../domain/puzzle_difficulty.dart';
import '../domain/puzzle_game.dart';
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
  bool _paused = false;
  bool _solvedHandled = false;

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
      if (!_paused && mounted) setState(() => _elapsed++);
    });
  }

  void _onSwap(int a, int b) {
    setState(() => _game.swap(a, b));
    if (_game.isSolved) _onSolved();
  }

  Future<void> _onSolved() async {
    if (_solvedHandled) return;
    _solvedHandled = true;
    _timer?.cancel();

    final seconds = _elapsed;
    final moves = _game.moves;
    await ref.read(puzzleRepositoryProvider).recordResult(
          session: widget.session,
          difficulty: widget.difficulty,
          seconds: seconds,
          moves: moves,
        );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => VictoryScreen(
          session: widget.session,
          difficulty: widget.difficulty,
          seconds: seconds,
          moves: moves,
        ),
      ),
    );
  }

  void _togglePause() => setState(() => _paused = !_paused);

  void _restart() {
    setState(() {
      _game.reset();
      _elapsed = 0;
      _paused = false;
    });
    _startTimer();
  }

  void _showPreview() {
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
              child: const Text('Fermer'),
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
    return Scaffold(
      backgroundColor: AppColors.bleuNuit,
      appBar: AppBar(
        backgroundColor: AppColors.bleuNuit,
        foregroundColor: AppColors.cremeDoux,
        title: Text(_difficulty.label),
        actions: [
          IconButton(
            onPressed: _showPreview,
            icon: const Icon(Icons.image_outlined),
            tooltip: 'Aperçu',
          ),
          IconButton(
            onPressed: _togglePause,
            icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
            tooltip: _paused ? 'Reprendre' : 'Pause',
          ),
          IconButton(
            onPressed: _restart,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recommencer',
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
              return const Center(
                child: Text(
                  'Erreur de chargement de l\'image',
                  style: TextStyle(color: Colors.white70),
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
                        value: formatDuration(_elapsed),
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
  const _Stat({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.or),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFeatures: [FontFeature.tabularFigures()],
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
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'En pause',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onResume,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Reprendre'),
            ),
          ],
        ),
      ),
    );
  }
}
