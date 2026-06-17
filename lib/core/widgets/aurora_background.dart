import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Vibrant "aurora" backdrop: a dark base gradient with soft, heavily-blurred
/// colored blobs. Used behind glassmorphism content.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.bleuNuit, Color(0xFF0E2647), AppColors.bleuSecondaire],
            ),
          ),
        ),
        ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 90, sigmaY: 90),
          child: Stack(
            children: [
              _Blob(top: -70, left: -50, size: 260, color: AppColors.or.withValues(alpha: 0.45)),
              _Blob(top: 110, right: -70, size: 230, color: AppColors.violet.withValues(alpha: 0.40)),
              _Blob(bottom: 60, right: 10, size: 200, color: const Color(0xFF3FA9F5).withValues(alpha: 0.38)),
              _Blob(bottom: -50, left: 20, size: 260, color: AppColors.orClair.withValues(alpha: 0.30)),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

/// A frosted-glass panel (blurs whatever is behind it). Optionally tappable.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 24,
    this.tint,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (tint ?? Colors.white).withValues(alpha: tint == null ? 0.12 : 0.22),
            borderRadius: radius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
