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
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyMaster => 'Master';

  @override
  String get difficultyGrandMaster => 'Grandmaster';

  @override
  String get difficultyLegend => 'Legend';

  @override
  String get audienceEasy => 'Kids, seniors, beginners';

  @override
  String get audienceMedium => 'Casual players';

  @override
  String get audienceHard => 'More patient players';

  @override
  String get audienceExpert => 'Seasoned players';

  @override
  String get audienceMaster => 'Puzzle masters';

  @override
  String get audienceGrandMaster => 'Dedicated experts';

  @override
  String get audienceLegend => 'For legends only';

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
  String puzzleTimeLimit(Object time) {
    return 'Limit: $time';
  }

  @override
  String get defeatTitle => 'Time\'s up';

  @override
  String get defeatSubtitle => 'Match lost. Try again — you\'re almost there!';

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
  String get victoryHome => 'Home';

  @override
  String get victoryNewMemory => 'New memory';

  @override
  String get levelUnlockTitle => 'Level unlocked!';

  @override
  String levelUnlockSubtitle(Object level) {
    return '$level is now available.';
  }

  @override
  String get levelUnlockDismiss => 'Awesome!';

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
  String get homeCurrentLevel => 'Current level';

  @override
  String homeLevelMatches(int current, int total) {
    return '$current / $total games';
  }

  @override
  String homeUnlockNext(int current, int total, Object level) {
    return '$current / $total → $level';
  }

  @override
  String get homeLevelMax => 'Max level';

  @override
  String get homeResumeLastMatch => 'Finish last match';

  @override
  String get homeWinsLabel => 'Wins';

  @override
  String get homeUnlockLabel => 'Unlock';

  @override
  String homeGridSize(int size) {
    return '$size×$size grid';
  }

  @override
  String get profilesTitle => 'Profiles';

  @override
  String get profilesAdd => 'Add profile';

  @override
  String get profilesCreate => 'Create profile';

  @override
  String get profilesNameHint => 'Name or nickname';

  @override
  String get profilesActive => 'Active profile';

  @override
  String get profilesChooseAvatar => 'Choose a photo';

  @override
  String get profilesSwitch => 'Switch profile';

  @override
  String get profilesEdit => 'Edit';

  @override
  String get profilesEditTitle => 'Edit profile';

  @override
  String get profilesSave => 'Save';

  @override
  String get profilesDelete => 'Delete';

  @override
  String get profilesDeleteTitle => 'Delete this profile?';

  @override
  String get profilesDeleteBody =>
      'All memories, statistics, and progress for this profile will be permanently deleted.';

  @override
  String get profilesDeleteLast => 'You can\'t delete the last profile.';

  @override
  String get playNeedsPhotos => 'Add photos in My memories first.';

  @override
  String get menu => 'Menu';

  @override
  String get menuSectionPlay => 'Play';

  @override
  String get menuSectionProgress => 'Progress';

  @override
  String get menuSectionInfo => 'Information';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVision => 'Our vision';

  @override
  String get aboutIntro =>
      'Souvenir Puzzle turns your photos into calm, personal puzzles. Every game is a memory to rebuild piece by piece — with family, friends, or on your own.';

  @override
  String get aboutMission =>
      'We believe the photos on your phone deserve more than a forgotten album. This game gives them a gentle second life — no ads, no mandatory account.';

  @override
  String get aboutHowItWorks => 'The experience';

  @override
  String get aboutFeature1 =>
      'Add photos from your gallery — they stay on your device.';

  @override
  String get aboutFeature2 => 'Pick a level, from Easy (3×3) to Legend (9×9).';

  @override
  String get aboutFeature3 =>
      'Rebuild the image by swapping pieces at your own pace.';

  @override
  String get aboutFeature4 =>
      'No personal data is uploaded: full privacy by design.';

  @override
  String get aboutStudio => 'Studio';

  @override
  String get aboutStudioName => 'Koyra Games';

  @override
  String get aboutStudioTagline => 'Calm, emotional games for everyone.';

  @override
  String get aboutStudioBody =>
      'Souvenir Puzzle is carefully built by a small independent studio. Every update aims to make the experience smoother, warmer, and more beautiful.';

  @override
  String get aboutPrivacyTitle => 'Privacy';

  @override
  String get aboutPrivacyBody =>
      'Your photos and data stay on your device. No account is required. You can clear your history anytime in Settings.';

  @override
  String get aboutSupportTitle => 'Support the project';

  @override
  String get aboutSupportHeadline => 'Enjoying Souvenir Puzzle?';

  @override
  String get aboutSupportIntro =>
      'If this game means something to you, you can help keep it alive — bug fixes, new features, translations, and upkeep all take real time.';

  @override
  String get aboutSupportWhy =>
      'Even a small contribution helps improve the app for everyone. Thank you from the bottom of my heart.';

  @override
  String get aboutSupportThanks =>
      'Thank you for your trust and generosity. Every bit of support matters.';

  @override
  String get aboutContactCta => 'Contact & support';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get getStartedTitle => 'Get started';

  @override
  String get getStartedIntro =>
      'Here\'s how to enjoy Souvenir Puzzle in a few simple steps.';

  @override
  String get getStartedStep1Title => 'Add your photos';

  @override
  String get getStartedStep1Body =>
      'In My memories, add one or more photos from your gallery.';

  @override
  String get getStartedStep2Title => 'Pick a level';

  @override
  String get getStartedStep2Body =>
      'From Easy (3×3) to Legend (9×9) — progress by winning games.';

  @override
  String get getStartedStep3Title => 'Rebuild the image';

  @override
  String get getStartedStep3Body =>
      'Drag pieces to swap them until your memory is complete.';

  @override
  String get getStartedStep4Title => 'Pause and celebrate';

  @override
  String get getStartedStep4Body =>
      'Pause anytime, preview the original image, then enjoy your victory.';

  @override
  String get getStartedCreatePuzzle => 'Create my first puzzle';

  @override
  String get getStartedOpenMemories => 'Go to My memories';

  @override
  String get contactTitle => 'Contact & support';

  @override
  String get contactIntro =>
      'A question, an idea, or just want to say hi? Reach out — and if you enjoy Souvenir Puzzle, you can offer me a coffee.';

  @override
  String get contactSectionContact => 'Contact';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get contactSectionCoffee => 'Offer me a coffee';

  @override
  String get contactOrangeMoney => 'Orange Money';

  @override
  String get contactPaypal => 'PayPal';

  @override
  String get contactCopied => 'Copied to clipboard';

  @override
  String get contactCouldNotOpen => 'Couldn\'t open the app';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsMemories => 'Memories';

  @override
  String get statsCompleted => 'Completed';

  @override
  String get statsTotalTime => 'Total time';

  @override
  String get statsTotalMoves => 'Total moves';

  @override
  String get statsByLevel => 'By level';

  @override
  String get statsBest => 'Best';

  @override
  String get statsNoData => 'Play a puzzle to see your statistics.';

  @override
  String get statsOverview => 'Overview';

  @override
  String get statsActivityChart => 'Activity · 14 days';

  @override
  String get statsActivitySubtitle => 'Puzzles completed per day';

  @override
  String get statsTimeTrend => 'Average time · 14 days';

  @override
  String get statsTimeTrendSubtitle => 'Average solve time per game (min)';

  @override
  String get statsStreak => 'Current streak';

  @override
  String statsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'No streak',
    );
    return '$_temp0';
  }

  @override
  String get statsAvgSolve => 'Avg. solve time';

  @override
  String get statsWinsPerDay => 'Wins / day';

  @override
  String get statsDifficultyBreakdown => 'Breakdown by level';

  @override
  String get statsLevelDetails => 'Level details';

  @override
  String get statsPeriod7 => '7 d';

  @override
  String get statsPeriod14 => '14 d';

  @override
  String get statsPeriod30 => '30 d';

  @override
  String get statsInsights => 'Trends';

  @override
  String get statsThisWeek => 'This week';

  @override
  String statsWeekChangeUp(int percent) {
    return '+$percent% vs last week';
  }

  @override
  String statsWeekChangeDown(int percent) {
    return '$percent% vs last week';
  }

  @override
  String get statsWeekChangeSame => 'Stable vs last week';

  @override
  String get statsWeekChangeNew => 'First active week';

  @override
  String get statsFavoriteLevel => 'Favorite level';

  @override
  String get statsBestStreak => 'Best streak';

  @override
  String get statsActiveDays => 'Active days';

  @override
  String get statsRegularity => 'Consistency';

  @override
  String get statsPeakDay => 'Best day';

  @override
  String statsPeakWins(int count) {
    return '$count games';
  }

  @override
  String statsTotalInPeriod(int count) {
    return '$count games in period';
  }

  @override
  String statsAvgPerDay(String avg) {
    return '$avg / day on average';
  }

  @override
  String get statsDistribution => 'Distribution';

  @override
  String get statsProgression => 'Progress';

  @override
  String get statsTapChartHint => 'Tap the chart for details';
}
