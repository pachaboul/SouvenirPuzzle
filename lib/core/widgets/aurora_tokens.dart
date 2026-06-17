import 'package:flutter/material.dart';

import '../../app/theme.dart';

/// Theme-aware colours for aurora / glass UI.
class AuroraTokens {
  const AuroraTokens._(this.brightness);

  final Brightness brightness;

  bool get isDark => brightness == Brightness.dark;

  factory AuroraTokens.of(BuildContext context) =>
      AuroraTokens._(Theme.of(context).brightness);

  List<Color> get backgroundGradient => isDark
      ? const [
          AppColors.bleuNuit,
          Color(0xFF0E2647),
          AppColors.bleuSecondaire,
        ]
      : const [
          AppColors.cremeDoux,
          AppColors.beige,
          Color(0xFFE6EFF8),
        ];

  List<({double? top, double? left, double? right, double? bottom, double size, Color color})>
      get blobs => isDark
          ? [
              (top: -70.0, left: -50.0, right: null, bottom: null, size: 260.0, color: AppColors.or.withValues(alpha: 0.45)),
              (top: 110.0, left: null, right: -70.0, bottom: null, size: 230.0, color: AppColors.violet.withValues(alpha: 0.40)),
              (top: null, left: null, right: 10.0, bottom: 60.0, size: 200.0, color: const Color(0xFF3FA9F5).withValues(alpha: 0.38)),
              (top: null, left: 20.0, right: null, bottom: -50.0, size: 260.0, color: AppColors.orClair.withValues(alpha: 0.30)),
            ]
          : [
              (top: -60.0, left: -40.0, right: null, bottom: null, size: 240.0, color: AppColors.or.withValues(alpha: 0.28)),
              (top: 90.0, left: null, right: -60.0, bottom: null, size: 210.0, color: AppColors.violet.withValues(alpha: 0.18)),
              (top: null, left: null, right: 0.0, bottom: 50.0, size: 190.0, color: const Color(0xFF3FA9F5).withValues(alpha: 0.16)),
              (top: null, left: 10.0, right: null, bottom: -40.0, size: 240.0, color: AppColors.orClair.withValues(alpha: 0.22)),
            ];

  Color get glassSurface =>
      isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.78);

  Color get glassBorder => isDark
      ? Colors.white.withValues(alpha: 0.25)
      : AppColors.cremeBordure.withValues(alpha: 0.95);

  Color get onGlass => isDark ? AppColors.cremeDoux : AppColors.encre;

  Color get onGlassMuted => isDark ? Colors.white70 : AppColors.grisDoux;

  Color get onGlassSubtle => isDark ? Colors.white54 : AppColors.grisDoux;

  Color get divider => isDark ? Colors.white24 : AppColors.cremeBordure;

  /// Subtle filled surfaces (chips, chart tracks).
  Color get surfaceSubtle =>
      isDark ? Colors.white.withValues(alpha: 0.06) : AppColors.encre.withValues(alpha: 0.06);

  Color get surfaceElevated =>
      isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.encre.withValues(alpha: 0.05);

  /// Grid lines and chart guides.
  Color get chartGrid =>
      isDark ? Colors.white.withValues(alpha: 0.06) : AppColors.encre.withValues(alpha: 0.08);

  /// Secondary chart / axis labels.
  Color get chartLabel =>
      isDark ? Colors.white.withValues(alpha: 0.45) : AppColors.grisDoux;

  /// Text on strongly tinted glass cards (orange, red).
  Color get onTintedCard => AppColors.encre;

  List<Color> get shellNavGradient => isDark
      ? const [AppColors.bleuNuit, AppColors.bleuSecondaire]
      : [Colors.white, AppColors.cremeDoux];

  Color get shellNavShadow =>
      isDark ? AppColors.bleuNuit.withValues(alpha: 0.45) : AppColors.encre.withValues(alpha: 0.12);

  Color get shellNavIcon => isDark ? Colors.white70 : AppColors.grisDoux;

  List<Color> get drawerGradient => isDark
      ? const [AppColors.bleuSecondaire, AppColors.bleuNuit]
      : const [AppColors.cremeDoux, AppColors.beige];

  Color get drawerMuted => isDark ? Colors.white70 : AppColors.grisDoux;

  Color get drawerFooter => isDark ? Colors.white38 : AppColors.grisDoux;

  Color get drawerItemText => isDark ? Colors.white : AppColors.encre;

  Color get drawerItemIcon => isDark ? Colors.white70 : AppColors.grisDoux;

  Color get drawerSection => isDark ? Colors.white38 : AppColors.grisDoux;
}
