import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../domain/puzzle_game.dart';

/// The interactive puzzle grid. Each cell is both a [Draggable] (you can pick
/// it up) and a [DragTarget] (you can drop another piece onto it); dropping
/// swaps the two pieces. Pass `onSwap == null` to disable interaction (e.g.
/// while paused).
class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    super.key,
    required this.image,
    required this.game,
    required this.onSwap,
  });

  final ui.Image image;
  final PuzzleGame game;
  final void Function(int a, int b)? onSwap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = game.size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cell = constraints.maxWidth / size;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size,
            ),
            itemCount: game.pieceCount,
            itemBuilder: (context, position) {
              final correctIndex = game.board[position];
              final tile = _PieceTile(
                image: image,
                correctIndex: correctIndex,
                gridSize: size,
              );

              if (onSwap == null) return tile;

              return DragTarget<int>(
                onWillAcceptWithDetails: (details) => details.data != position,
                onAcceptWithDetails: (details) => onSwap!(details.data, position),
                builder: (context, candidate, rejected) {
                  final highlighted = candidate.isNotEmpty;
                  return Draggable<int>(
                    data: position,
                    feedback: Material(
                      elevation: 8,
                      child: SizedBox(
                        width: cell,
                        height: cell,
                        child: _PieceTile(
                          image: image,
                          correctIndex: correctIndex,
                          gridSize: size,
                        ),
                      ),
                    ),
                    childWhenDragging: Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: highlighted
                              ? theme.colorScheme.primary
                              : Colors.white24,
                          width: highlighted ? 2 : 0.5,
                        ),
                      ),
                      child: tile,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PieceTile extends StatelessWidget {
  const _PieceTile({
    required this.image,
    required this.correctIndex,
    required this.gridSize,
  });

  final ui.Image image;
  final int correctIndex;
  final int gridSize;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiecePainter(
        image: image,
        correctIndex: correctIndex,
        gridSize: gridSize,
      ),
      child: const SizedBox.expand(),
    );
  }
}

/// Paints a single puzzle piece by drawing the matching sub-rectangle of the
/// source image. The image is center-cropped to a square so pieces stay square
/// and undistorted regardless of the original aspect ratio.
class _PiecePainter extends CustomPainter {
  _PiecePainter({
    required this.image,
    required this.correctIndex,
    required this.gridSize,
  });

  final ui.Image image;
  final int correctIndex;
  final int gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    final side = image.width < image.height
        ? image.width.toDouble()
        : image.height.toDouble();
    final originX = (image.width - side) / 2;
    final originY = (image.height - side) / 2;
    final pieceSide = side / gridSize;

    final col = correctIndex % gridSize;
    final row = correctIndex ~/ gridSize;

    final src = Rect.fromLTWH(
      originX + col * pieceSide,
      originY + row * pieceSide,
      pieceSide,
      pieceSide,
    );
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_PiecePainter oldDelegate) =>
      oldDelegate.image != image ||
      oldDelegate.correctIndex != correctIndex ||
      oldDelegate.gridSize != gridSize;
}
