/// Application-wide constants for Souvenir Puzzle.
class AppConstants {
  AppConstants._();

  static const String appName = 'Souvenir Puzzle';
  static const String version = '1.2.0';
  static const String tagline =
      'Transformez vos photos en puzzles et revivez vos souvenirs pièce par pièce.';

  /// Privacy reassurance shown on the photo picker.
  static const String privacyNote = 'Vos photos restent sur votre téléphone.';

  /// Large photos are decoded down to this width to stay fast and memory-safe.
  static const int maxImageDecodeWidth = 1024;
}
