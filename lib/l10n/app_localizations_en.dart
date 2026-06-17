// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Souvenir Puzzle';

  @override
  String get splashTagline => 'Each piece tells a story.';

  @override
  String get homeTagline =>
      'Turn your photos into puzzles and relive your memories piece by piece.';

  @override
  String get homeCreatePuzzle => 'Create a puzzle';

  @override
  String get homeMyMemories => 'My memories';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonReplay => 'Replay';

  @override
  String get commonStart => 'Start';

  @override
  String get photoTitle => 'Choose a photo';

  @override
  String get photoPrivacyNote => 'Your photos stay on your phone.';

  @override
  String photoGalleryError(Object error) {
    return 'Couldn\'t open the gallery: $error';
  }

  @override
  String get photoChoose => 'Choose a photo';

  @override
  String get photoChange => 'Change photo';

  @override
  String get photoTapToChoose => 'Tap to choose a photo';

  @override
  String get difficultyTitle => 'Difficulty';

  @override
  String get difficultyChoose => 'Choose a level';

  @override
  String createError(Object error) {
    return 'Couldn\'t create the puzzle: $error';
  }

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get audienceEasy => 'Kids, seniors, beginners';

  @override
  String get audienceMedium => 'Casual players';

  @override
  String get audienceHard => 'More patient players';

  @override
  String winsProgress(int count, int total) {
    return '$count / $total wins';
  }

  @override
  String lockHint(int total, Object level) {
    return 'Win $total games in $level to unlock';
  }

  @override
  String get locked => 'Locked';

  @override
  String get puzzlePreview => 'Preview';

  @override
  String get puzzlePause => 'Pause';

  @override
  String get puzzleResume => 'Resume';

  @override
  String get puzzleRestart => 'Restart';

  @override
  String get puzzlePaused => 'Paused';

  @override
  String get puzzleImageError => 'Couldn\'t load the image';

  @override
  String get victoryTitle => 'Congratulations!';

  @override
  String get victorySubtitle => 'Memory completed.';

  @override
  String get statTime => 'Time';

  @override
  String get statMoves => 'Moves';

  @override
  String get victoryNext => 'Next';

  @override
  String get victoryNewMemory => 'New memory';

  @override
  String get memoriesTitle => 'My memories';

  @override
  String memoriesCountTitle(int count) {
    return 'My memories ($count)';
  }

  @override
  String get memoriesAdd => 'Add photos';

  @override
  String get memoriesPlay => 'Play';

  @override
  String memoriesLimitReached(int max) {
    return 'Limit of $max photos reached.';
  }

  @override
  String memoriesPartiallyAdded(int count, int max) {
    return '$count photo(s) added — limit of $max reached.';
  }

  @override
  String memoriesAddError(Object error) {
    return 'Couldn\'t add the photos: $error';
  }

  @override
  String get memoriesDeleteTitle => 'Delete this memory?';

  @override
  String get memoriesDeleteBody =>
      'The puzzle and its thumbnail will be deleted. Your original photo is not affected.';

  @override
  String memoriesPlayedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Played $count times',
      one: 'Played once',
      zero: 'Never played',
    );
    return '$_temp0';
  }

  @override
  String get memoriesReadyToPlay => 'Photo ready to play';

  @override
  String get memoriesEmptyTitle => 'No memories yet';

  @override
  String get memoriesEmptyBody =>
      'Add your photos, then tap Play for a random puzzle.';

  @override
  String get settingsSectionGame => 'Game';

  @override
  String get settingsSound => 'Sound';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get settingsSectionPrivacy => 'Privacy';

  @override
  String get settingsPrivacyText =>
      'Your privacy matters. Souvenir Puzzle never uploads your photos: everything stays on your phone.';

  @override
  String get settingsClearHistory => 'Delete all memories';

  @override
  String get settingsClearTitle => 'Delete all memories?';

  @override
  String get settingsClearBody =>
      'All your puzzles and their thumbnails will be deleted. Your original photos are not affected.';

  @override
  String get commonErase => 'Erase';

  @override
  String get settingsCleared => 'Memories erased.';

  @override
  String errorPrefix(Object error) {
    return 'Error: $error';
  }

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get navHome => 'Home';

  @override
  String get homePlay => 'Play';

  @override
  String get playNeedsPhotos => 'Add photos in My memories first.';

  @override
  String get menu => 'Menu';
}
