import 'package:flutter/material.dart';

/// Spacing and sizing tuned for small phone screens (height &lt; 720).
class CompactLayout {
  CompactLayout._();

  static bool of(BuildContext context) =>
      MediaQuery.sizeOf(context).height < 720;

  static EdgeInsets pagePadding(BuildContext context) => of(context)
      ? const EdgeInsets.fromLTRB(16, 4, 16, 12)
      : const EdgeInsets.fromLTRB(24, 8, 24, 24);

  static double bottomNavClearance(BuildContext context) =>
      of(context) ? 72.0 : 88.0;

  static double homeLogoHeight(BuildContext context) => of(context) ? 64.0 : 96.0;

  static double resumeThumbHeight(BuildContext context) =>
      of(context) ? 88.0 : 132.0;

}
