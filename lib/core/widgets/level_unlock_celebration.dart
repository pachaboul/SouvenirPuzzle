import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/aurora_background.dart';
import '../../core/widgets/aurora_tokens.dart';
import '../../features/puzzle/domain/puzzle_difficulty.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_difficulty.dart';

/// Full-screen falling confetti / flowers / gifts when a new level unlocks.
class LevelUnlockCelebration extends StatefulWidget {
  const LevelUnlockCelebration({
    super.key,
    required this.unlocked,
    required this.onDismiss,
  });

  final PuzzleDifficulty unlocked;
  final VoidCallback onDismiss;

  static const _emojis = ['🌸', '🌺', '💐', '🎁', '🎉', '✨', '🌼', '🎊'];

  @override
  State<LevelUnlockCelebration> createState() => _LevelUnlockCelebrationState();
}

class _LevelUnlockCelebrationState extends State<LevelUnlockCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4500),
  )..forward();

  late final List<_FallingParticle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(48, (_) => _FallingParticle.random(_random));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onDismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _particleVisible(_FallingParticle p) {
    final y = p.startY + _controller.value * p.speed;
    return y >= -0.1 && y <= 1.15;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tokens = AuroraTokens.of(context);
    final accent = AppColors.difficulty(widget.unlocked);
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: widget.onDismiss,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: AppColors.bleuNuit.withValues(alpha: 0.72)),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final size = MediaQuery.sizeOf(context);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      size: size,
                      painter: _ConfettiPainter(
                        particles: _particles,
                        progress: _controller.value,
                      ),
                    ),
                    for (final p in _particles)
                      if (_particleVisible(p))
                        Positioned(
                          left: size.width *
                              (p.startX +
                                  sin(_controller.value * pi * p.wobble) * 0.08),
                          top: size.height * (p.startY + _controller.value * p.speed),
                          child: Transform.rotate(
                            angle: p.rotation + _controller.value * p.spin,
                            child: Text(
                              p.emoji,
                              style: TextStyle(fontSize: p.size),
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.6, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: GlassCard(
                  borderRadius: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                  tint: AppColors.or,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎁', style: TextStyle(fontSize: 52)),
                      const SizedBox(height: 12),
                      Text(
                        l.levelUnlockTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tokens.onTintedCard,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: accent, width: 2),
                        ),
                        child: Text(
                          widget.unlocked.label(l),
                          style: TextStyle(
                            color: accent,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l.levelUnlockSubtitle(widget.unlocked.label(l)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tokens.onTintedCard.withValues(alpha: 0.75),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.or,
                          foregroundColor: AppColors.encre,
                        ),
                        onPressed: widget.onDismiss,
                        child: Text(l.levelUnlockDismiss),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FallingParticle {
  _FallingParticle({
    required this.startX,
    required this.startY,
    required this.speed,
    required this.wobble,
    required this.rotation,
    required this.spin,
    required this.size,
    required this.emoji,
  });

  final double startX;
  final double startY;
  final double speed;
  final double wobble;
  final double rotation;
  final double spin;
  final double size;
  final String emoji;

  factory _FallingParticle.random(Random random) {
    return _FallingParticle(
      startX: random.nextDouble(),
      startY: -0.15 - random.nextDouble() * 0.5,
      speed: 1.1 + random.nextDouble() * 0.9,
      wobble: 0.5 + random.nextDouble() * 2,
      rotation: random.nextDouble() * pi * 2,
      spin: (random.nextDouble() - 0.5) * 4,
      size: 18 + random.nextDouble() * 16,
      emoji: LevelUnlockCelebration._emojis[
          random.nextInt(LevelUnlockCelebration._emojis.length)],
    );
  }
}

/// Coloured confetti rectangles behind the emoji layer.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_FallingParticle> particles;
  final double progress;

  static const _colors = [
    AppColors.or,
    AppColors.orClair,
    AppColors.vert,
    AppColors.violet,
    Color(0xFF3FA9F5),
    Colors.white,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < particles.length; i++) {
      final p = particles[i];
      final y = (p.startY + progress * p.speed) * size.height;
      final x = (p.startX + sin(progress * pi * p.wobble) * 0.08) * size.width;
      if (y < -20 || y > size.height + 20) continue;
      paint.color = _colors[i % _colors.length].withValues(alpha: 0.85);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation + progress * p.spin);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 8, height: 14),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
