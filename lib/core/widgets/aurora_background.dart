import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'aurora_tokens.dart';

/// Vibrant "aurora" backdrop: adapts to light/dark [Theme].
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = AuroraTokens.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: tokens.backgroundGradient,
            ),
          ),
        ),
        ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 90, sigmaY: 90),
          child: Stack(
            children: [
              for (final blob in tokens.blobs)
                _Blob(
                  top: blob.top,
                  left: blob.left,
                  right: blob.right,
                  bottom: blob.bottom,
                  size: blob.size,
                  color: blob.color,
                ),
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
    final tokens = AuroraTokens.of(context);
    final radius = BorderRadius.circular(borderRadius);
    final fill = tint == null
        ? tokens.glassSurface
        : tint!.withValues(alpha: tokens.isDark ? 0.22 : 0.35);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: tokens.glassBorder),
            boxShadow: tokens.isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.encre.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
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
