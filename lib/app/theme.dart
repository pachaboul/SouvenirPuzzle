import 'package:flutter/material.dart';

import '../features/puzzle/domain/puzzle_difficulty.dart';

/// Souvenir Puzzle brand palette (charte graphique).
class AppColors {
  AppColors._();

  static const Color bleuNuit = Color(0xFF071B34); // primary brand
  static const Color bleuSecondaire = Color(0xFF123A63);
  static const Color or = Color(0xFFD7AA57); // "Or Mémoire" — emotion/premium
  static const Color orClair = Color(0xFFF3CC82);
  static const Color cremeDoux = Color(0xFFFFF8ED); // light surface
  static const Color beige = Color(0xFFF4EADC); // general background
  static const Color encre = Color(0xFF132235); // primary text
  static const Color grisDoux = Color(0xFF6E7B8E); // secondary text
  static const Color cremeBordure = Color(0xFFEADFCE);
  static const Color vert = Color(0xFF7FA985); // success / Facile
  static const Color violet = Color(0xFF8D6CCC); // Difficile
  static const Color rouge = Color(0xFFE7634F); // danger

  static const Color teal = Color(0xFF2BB7A3); // Expert
  static const Color rose = Color(0xFFE0556E); // Master

  /// Accent colour per difficulty.
  static Color difficulty(PuzzleDifficulty difficulty) {
    switch (difficulty) {
      case PuzzleDifficulty.easy:
        return vert;
      case PuzzleDifficulty.medium:
        return or;
      case PuzzleDifficulty.hard:
        return violet;
      case PuzzleDifficulty.expert:
        return teal;
      case PuzzleDifficulty.master:
        return rose;
    }
  }
}

/// Calm, premium, family-friendly theme built from the brand palette.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.bleuNuit,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.bleuNuit,
      onPrimary: Colors.white,
      secondary: AppColors.or,
      onSecondary: AppColors.encre,
      surface: AppColors.cremeDoux,
      onSurface: AppColors.encre,
      onSurfaceVariant: AppColors.grisDoux,
      outlineVariant: AppColors.cremeBordure,
      error: AppColors.rouge,
    );
    return _base(scheme, scaffold: AppColors.cremeDoux, cardColor: Colors.white);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.or,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.or,
      onPrimary: AppColors.encre,
      secondary: AppColors.orClair,
      surface: AppColors.bleuSecondaire,
      onSurface: AppColors.cremeDoux,
      error: AppColors.rouge,
    );
    return _base(
      scheme,
      scaffold: AppColors.bleuNuit,
      cardColor: AppColors.bleuSecondaire,
    );
  }

  static ThemeData _base(
    ColorScheme scheme, {
    required Color scaffold,
    required Color cardColor,
  }) {
    const buttonText = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);
    const buttonSize = Size.fromHeight(56);
    // Fully rounded ("999px") buttons per the charte.
    final stadium = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(999),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: buttonText,
          shape: stadium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          textStyle: buttonText,
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.outlineVariant),
          shape: stadium,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.or,
        foregroundColor: AppColors.encre,
      ),
    );
  }
}
