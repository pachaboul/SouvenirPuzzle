import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Souvenir Puzzle'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Each piece tells a story.'**
  String get splashTagline;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Turn your photos into puzzles and relive your memories piece by piece.'**
  String get homeTagline;

  /// No description provided for @homeCreatePuzzle.
  ///
  /// In en, this message translates to:
  /// **'Create a puzzle'**
  String get homeCreatePuzzle;

  /// No description provided for @homeMyMemories.
  ///
  /// In en, this message translates to:
  /// **'My memories'**
  String get homeMyMemories;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get commonReplay;

  /// No description provided for @commonStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get commonStart;

  /// No description provided for @photoTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get photoTitle;

  /// No description provided for @photoPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your photos stay on your phone.'**
  String get photoPrivacyNote;

  /// No description provided for @photoGalleryError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the gallery: {error}'**
  String photoGalleryError(Object error);

  /// No description provided for @photoChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get photoChoose;

  /// No description provided for @photoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get photoChange;

  /// No description provided for @photoTapToChoose.
  ///
  /// In en, this message translates to:
  /// **'Tap to choose a photo'**
  String get photoTapToChoose;

  /// No description provided for @difficultyTitle.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficultyTitle;

  /// No description provided for @difficultyChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a level'**
  String get difficultyChoose;

  /// No description provided for @createError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the puzzle: {error}'**
  String createError(Object error);

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get difficultyExpert;

  /// No description provided for @difficultyMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get difficultyMaster;

  /// No description provided for @difficultyGrandMaster.
  ///
  /// In en, this message translates to:
  /// **'Grandmaster'**
  String get difficultyGrandMaster;

  /// No description provided for @difficultyLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get difficultyLegend;

  /// No description provided for @audienceEasy.
  ///
  /// In en, this message translates to:
  /// **'Kids, seniors, beginners'**
  String get audienceEasy;

  /// No description provided for @audienceMedium.
  ///
  /// In en, this message translates to:
  /// **'Casual players'**
  String get audienceMedium;

  /// No description provided for @audienceHard.
  ///
  /// In en, this message translates to:
  /// **'More patient players'**
  String get audienceHard;

  /// No description provided for @audienceExpert.
  ///
  /// In en, this message translates to:
  /// **'Seasoned players'**
  String get audienceExpert;

  /// No description provided for @audienceMaster.
  ///
  /// In en, this message translates to:
  /// **'Puzzle masters'**
  String get audienceMaster;

  /// No description provided for @audienceGrandMaster.
  ///
  /// In en, this message translates to:
  /// **'Dedicated experts'**
  String get audienceGrandMaster;

  /// No description provided for @audienceLegend.
  ///
  /// In en, this message translates to:
  /// **'For legends only'**
  String get audienceLegend;

  /// No description provided for @winsProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} / {total} wins'**
  String winsProgress(int count, int total);

  /// No description provided for @lockHint.
  ///
  /// In en, this message translates to:
  /// **'Win {total} games in {level} to unlock'**
  String lockHint(int total, Object level);

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @puzzlePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get puzzlePreview;

  /// No description provided for @puzzlePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get puzzlePause;

  /// No description provided for @puzzleResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get puzzleResume;

  /// No description provided for @puzzleRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get puzzleRestart;

  /// No description provided for @puzzlePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get puzzlePaused;

  /// No description provided for @puzzleImageError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the image'**
  String get puzzleImageError;

  /// No description provided for @puzzleTimeLimit.
  ///
  /// In en, this message translates to:
  /// **'Limit: {time}'**
  String puzzleTimeLimit(Object time);

  /// No description provided for @defeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up'**
  String get defeatTitle;

  /// No description provided for @defeatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match lost. Try again — you\'re almost there!'**
  String get defeatSubtitle;

  /// No description provided for @victoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get victoryTitle;

  /// No description provided for @victorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Memory completed.'**
  String get victorySubtitle;

  /// No description provided for @statTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get statTime;

  /// No description provided for @statMoves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get statMoves;

  /// No description provided for @victoryNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get victoryNext;

  /// No description provided for @victoryHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get victoryHome;

  /// No description provided for @victoryNewMemory.
  ///
  /// In en, this message translates to:
  /// **'New memory'**
  String get victoryNewMemory;

  /// No description provided for @levelUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Level unlocked!'**
  String get levelUnlockTitle;

  /// No description provided for @levelUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{level} is now available.'**
  String levelUnlockSubtitle(Object level);

  /// No description provided for @levelUnlockDismiss.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get levelUnlockDismiss;

  /// No description provided for @memoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'My memories'**
  String get memoriesTitle;

  /// No description provided for @memoriesCountTitle.
  ///
  /// In en, this message translates to:
  /// **'My memories ({count})'**
  String memoriesCountTitle(int count);

  /// No description provided for @memoriesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get memoriesAdd;

  /// No description provided for @memoriesPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get memoriesPlay;

  /// No description provided for @memoriesLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit of {max} photos reached.'**
  String memoriesLimitReached(int max);

  /// No description provided for @memoriesPartiallyAdded.
  ///
  /// In en, this message translates to:
  /// **'{count} photo(s) added — limit of {max} reached.'**
  String memoriesPartiallyAdded(int count, int max);

  /// No description provided for @memoriesAddError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t add the photos: {error}'**
  String memoriesAddError(Object error);

  /// No description provided for @memoriesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get memoriesDeleteTitle;

  /// No description provided for @memoriesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'The puzzle and its thumbnail will be deleted. Your original photo is not affected.'**
  String get memoriesDeleteBody;

  /// No description provided for @memoriesPlayedTimes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Never played} =1{Played once} other{Played {count} times}}'**
  String memoriesPlayedTimes(int count);

  /// No description provided for @memoriesReadyToPlay.
  ///
  /// In en, this message translates to:
  /// **'Photo ready to play'**
  String get memoriesReadyToPlay;

  /// No description provided for @memoriesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No memories yet'**
  String get memoriesEmptyTitle;

  /// No description provided for @memoriesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your photos, then tap Play for a random puzzle.'**
  String get memoriesEmptyBody;

  /// No description provided for @settingsSectionGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get settingsSectionGame;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get settingsSound;

  /// No description provided for @settingsVibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters. Souvenir Puzzle never uploads your photos: everything stays on your phone.'**
  String get settingsPrivacyText;

  /// No description provided for @settingsClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete all memories'**
  String get settingsClearHistory;

  /// No description provided for @settingsClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all memories?'**
  String get settingsClearTitle;

  /// No description provided for @settingsClearBody.
  ///
  /// In en, this message translates to:
  /// **'All your puzzles and their thumbnails will be deleted. Your original photos are not affected.'**
  String get settingsClearBody;

  /// No description provided for @commonErase.
  ///
  /// In en, this message translates to:
  /// **'Erase'**
  String get commonErase;

  /// No description provided for @settingsCleared.
  ///
  /// In en, this message translates to:
  /// **'Memories erased.'**
  String get settingsCleared;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorPrefix(Object error);

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @homePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get homePlay;

  /// No description provided for @homeCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current level'**
  String get homeCurrentLevel;

  /// No description provided for @homeLevelMatches.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} games'**
  String homeLevelMatches(int current, int total);

  /// No description provided for @homeUnlockNext.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} → {level}'**
  String homeUnlockNext(int current, int total, Object level);

  /// No description provided for @homeLevelMax.
  ///
  /// In en, this message translates to:
  /// **'Max level'**
  String get homeLevelMax;

  /// No description provided for @homeResumeLastMatch.
  ///
  /// In en, this message translates to:
  /// **'Finish last match'**
  String get homeResumeLastMatch;

  /// No description provided for @homeWinsLabel.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get homeWinsLabel;

  /// No description provided for @homeUnlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get homeUnlockLabel;

  /// No description provided for @homeGridSize.
  ///
  /// In en, this message translates to:
  /// **'{size}×{size} grid'**
  String homeGridSize(int size);

  /// No description provided for @profilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profilesTitle;

  /// No description provided for @profilesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add profile'**
  String get profilesAdd;

  /// No description provided for @profilesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get profilesCreate;

  /// No description provided for @profilesNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name or nickname'**
  String get profilesNameHint;

  /// No description provided for @profilesActive.
  ///
  /// In en, this message translates to:
  /// **'Active profile'**
  String get profilesActive;

  /// No description provided for @profilesChooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose a photo'**
  String get profilesChooseAvatar;

  /// No description provided for @profilesSwitch.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get profilesSwitch;

  /// No description provided for @profilesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profilesEdit;

  /// No description provided for @profilesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profilesEditTitle;

  /// No description provided for @profilesSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profilesSave;

  /// No description provided for @profilesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profilesDelete;

  /// No description provided for @profilesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this profile?'**
  String get profilesDeleteTitle;

  /// No description provided for @profilesDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'All memories, statistics, and progress for this profile will be permanently deleted.'**
  String get profilesDeleteBody;

  /// No description provided for @profilesDeleteLast.
  ///
  /// In en, this message translates to:
  /// **'You can\'t delete the last profile.'**
  String get profilesDeleteLast;

  /// No description provided for @playNeedsPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos in My memories first.'**
  String get playNeedsPhotos;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @menuSectionPlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get menuSectionPlay;

  /// No description provided for @menuSectionProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get menuSectionProgress;

  /// No description provided for @menuSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get menuSectionInfo;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutVision.
  ///
  /// In en, this message translates to:
  /// **'Our vision'**
  String get aboutVision;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Souvenir Puzzle turns your photos into calm, personal puzzles. Every game is a memory to rebuild piece by piece — with family, friends, or on your own.'**
  String get aboutIntro;

  /// No description provided for @aboutMission.
  ///
  /// In en, this message translates to:
  /// **'We believe the photos on your phone deserve more than a forgotten album. This game gives them a gentle second life — no ads, no mandatory account.'**
  String get aboutMission;

  /// No description provided for @aboutHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'The experience'**
  String get aboutHowItWorks;

  /// No description provided for @aboutFeature1.
  ///
  /// In en, this message translates to:
  /// **'Add photos from your gallery — they stay on your device.'**
  String get aboutFeature1;

  /// No description provided for @aboutFeature2.
  ///
  /// In en, this message translates to:
  /// **'Pick a level, from Easy (3×3) to Legend (9×9).'**
  String get aboutFeature2;

  /// No description provided for @aboutFeature3.
  ///
  /// In en, this message translates to:
  /// **'Rebuild the image by swapping pieces at your own pace.'**
  String get aboutFeature3;

  /// No description provided for @aboutFeature4.
  ///
  /// In en, this message translates to:
  /// **'No personal data is uploaded: full privacy by design.'**
  String get aboutFeature4;

  /// No description provided for @aboutStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get aboutStudio;

  /// No description provided for @aboutStudioName.
  ///
  /// In en, this message translates to:
  /// **'Koyra Games'**
  String get aboutStudioName;

  /// No description provided for @aboutStudioTagline.
  ///
  /// In en, this message translates to:
  /// **'Calm, emotional games for everyone.'**
  String get aboutStudioTagline;

  /// No description provided for @aboutStudioBody.
  ///
  /// In en, this message translates to:
  /// **'Souvenir Puzzle is carefully built by a small independent studio. Every update aims to make the experience smoother, warmer, and more beautiful.'**
  String get aboutStudioBody;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your photos and data stay on your device. No account is required. You can clear your history anytime in Settings.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get aboutSupportTitle;

  /// No description provided for @aboutSupportHeadline.
  ///
  /// In en, this message translates to:
  /// **'Enjoying Souvenir Puzzle?'**
  String get aboutSupportHeadline;

  /// No description provided for @aboutSupportIntro.
  ///
  /// In en, this message translates to:
  /// **'If this game means something to you, you can help keep it alive — bug fixes, new features, translations, and upkeep all take real time.'**
  String get aboutSupportIntro;

  /// No description provided for @aboutSupportWhy.
  ///
  /// In en, this message translates to:
  /// **'Even a small contribution helps improve the app for everyone. Thank you from the bottom of my heart.'**
  String get aboutSupportWhy;

  /// No description provided for @aboutSupportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your trust and generosity. Every bit of support matters.'**
  String get aboutSupportThanks;

  /// No description provided for @aboutContactCta.
  ///
  /// In en, this message translates to:
  /// **'Contact & support'**
  String get aboutContactCta;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(Object version);

  /// No description provided for @getStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStartedTitle;

  /// No description provided for @getStartedIntro.
  ///
  /// In en, this message translates to:
  /// **'Here\'s how to enjoy Souvenir Puzzle in a few simple steps.'**
  String get getStartedIntro;

  /// No description provided for @getStartedStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Add your photos'**
  String get getStartedStep1Title;

  /// No description provided for @getStartedStep1Body.
  ///
  /// In en, this message translates to:
  /// **'In My memories, add one or more photos from your gallery.'**
  String get getStartedStep1Body;

  /// No description provided for @getStartedStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Pick a level'**
  String get getStartedStep2Title;

  /// No description provided for @getStartedStep2Body.
  ///
  /// In en, this message translates to:
  /// **'From Easy (3×3) to Legend (9×9) — progress by winning games.'**
  String get getStartedStep2Body;

  /// No description provided for @getStartedStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Rebuild the image'**
  String get getStartedStep3Title;

  /// No description provided for @getStartedStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Drag pieces to swap them until your memory is complete.'**
  String get getStartedStep3Body;

  /// No description provided for @getStartedStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Pause and celebrate'**
  String get getStartedStep4Title;

  /// No description provided for @getStartedStep4Body.
  ///
  /// In en, this message translates to:
  /// **'Pause anytime, preview the original image, then enjoy your victory.'**
  String get getStartedStep4Body;

  /// No description provided for @getStartedCreatePuzzle.
  ///
  /// In en, this message translates to:
  /// **'Create my first puzzle'**
  String get getStartedCreatePuzzle;

  /// No description provided for @getStartedOpenMemories.
  ///
  /// In en, this message translates to:
  /// **'Go to My memories'**
  String get getStartedOpenMemories;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact & support'**
  String get contactTitle;

  /// No description provided for @contactIntro.
  ///
  /// In en, this message translates to:
  /// **'A question, an idea, or just want to say hi? Reach out — and if you enjoy Souvenir Puzzle, you can offer me a coffee.'**
  String get contactIntro;

  /// No description provided for @contactSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactSectionContact;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmailLabel;

  /// No description provided for @contactSectionCoffee.
  ///
  /// In en, this message translates to:
  /// **'Offer me a coffee'**
  String get contactSectionCoffee;

  /// No description provided for @contactOrangeMoney.
  ///
  /// In en, this message translates to:
  /// **'Orange Money'**
  String get contactOrangeMoney;

  /// No description provided for @contactPaypal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get contactPaypal;

  /// No description provided for @contactCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get contactCopied;

  /// No description provided for @contactCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the app'**
  String get contactCouldNotOpen;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTitle;

  /// No description provided for @statsMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get statsMemories;

  /// No description provided for @statsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statsCompleted;

  /// No description provided for @statsTotalTime.
  ///
  /// In en, this message translates to:
  /// **'Total time'**
  String get statsTotalTime;

  /// No description provided for @statsTotalMoves.
  ///
  /// In en, this message translates to:
  /// **'Total moves'**
  String get statsTotalMoves;

  /// No description provided for @statsByLevel.
  ///
  /// In en, this message translates to:
  /// **'By level'**
  String get statsByLevel;

  /// No description provided for @statsBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get statsBest;

  /// No description provided for @statsNoData.
  ///
  /// In en, this message translates to:
  /// **'Play a puzzle to see your statistics.'**
  String get statsNoData;

  /// No description provided for @statsOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get statsOverview;

  /// No description provided for @statsActivityChart.
  ///
  /// In en, this message translates to:
  /// **'Activity · 14 days'**
  String get statsActivityChart;

  /// No description provided for @statsActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Puzzles completed per day'**
  String get statsActivitySubtitle;

  /// No description provided for @statsTimeTrend.
  ///
  /// In en, this message translates to:
  /// **'Average time · 14 days'**
  String get statsTimeTrend;

  /// No description provided for @statsTimeTrendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Average solve time per game (min)'**
  String get statsTimeTrendSubtitle;

  /// No description provided for @statsStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get statsStreak;

  /// No description provided for @statsStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak} =1{1 day} other{{count} days}}'**
  String statsStreakDays(int count);

  /// No description provided for @statsAvgSolve.
  ///
  /// In en, this message translates to:
  /// **'Avg. solve time'**
  String get statsAvgSolve;

  /// No description provided for @statsWinsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Wins / day'**
  String get statsWinsPerDay;

  /// No description provided for @statsDifficultyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown by level'**
  String get statsDifficultyBreakdown;

  /// No description provided for @statsLevelDetails.
  ///
  /// In en, this message translates to:
  /// **'Level details'**
  String get statsLevelDetails;

  /// No description provided for @statsPeriod7.
  ///
  /// In en, this message translates to:
  /// **'7 d'**
  String get statsPeriod7;

  /// No description provided for @statsPeriod14.
  ///
  /// In en, this message translates to:
  /// **'14 d'**
  String get statsPeriod14;

  /// No description provided for @statsPeriod30.
  ///
  /// In en, this message translates to:
  /// **'30 d'**
  String get statsPeriod30;

  /// No description provided for @statsInsights.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get statsInsights;

  /// No description provided for @statsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get statsThisWeek;

  /// No description provided for @statsWeekChangeUp.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% vs last week'**
  String statsWeekChangeUp(int percent);

  /// No description provided for @statsWeekChangeDown.
  ///
  /// In en, this message translates to:
  /// **'{percent}% vs last week'**
  String statsWeekChangeDown(int percent);

  /// No description provided for @statsWeekChangeSame.
  ///
  /// In en, this message translates to:
  /// **'Stable vs last week'**
  String get statsWeekChangeSame;

  /// No description provided for @statsWeekChangeNew.
  ///
  /// In en, this message translates to:
  /// **'First active week'**
  String get statsWeekChangeNew;

  /// No description provided for @statsFavoriteLevel.
  ///
  /// In en, this message translates to:
  /// **'Favorite level'**
  String get statsFavoriteLevel;

  /// No description provided for @statsBestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best streak'**
  String get statsBestStreak;

  /// No description provided for @statsActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get statsActiveDays;

  /// No description provided for @statsRegularity.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get statsRegularity;

  /// No description provided for @statsPeakDay.
  ///
  /// In en, this message translates to:
  /// **'Best day'**
  String get statsPeakDay;

  /// No description provided for @statsPeakWins.
  ///
  /// In en, this message translates to:
  /// **'{count} games'**
  String statsPeakWins(int count);

  /// No description provided for @statsTotalInPeriod.
  ///
  /// In en, this message translates to:
  /// **'{count} games in period'**
  String statsTotalInPeriod(int count);

  /// No description provided for @statsAvgPerDay.
  ///
  /// In en, this message translates to:
  /// **'{avg} / day on average'**
  String statsAvgPerDay(String avg);

  /// No description provided for @statsDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get statsDistribution;

  /// No description provided for @statsProgression.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get statsProgression;

  /// No description provided for @statsTapChartHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the chart for details'**
  String get statsTapChartHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
