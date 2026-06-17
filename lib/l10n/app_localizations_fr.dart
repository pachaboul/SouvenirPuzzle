// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Souvenir Puzzle';

  @override
  String get splashTagline => 'Chaque pièce raconte une histoire.';

  @override
  String get homeTagline =>
      'Transformez vos photos en puzzles et revivez vos souvenirs pièce par pièce.';

  @override
  String get homeCreatePuzzle => 'Créer un puzzle';

  @override
  String get homeMyMemories => 'Mes souvenirs';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonReplay => 'Rejouer';

  @override
  String get commonStart => 'Commencer';

  @override
  String get photoTitle => 'Choisir une photo';

  @override
  String get photoPrivacyNote => 'Vos photos restent sur votre téléphone.';

  @override
  String photoGalleryError(Object error) {
    return 'Impossible d\'ouvrir la galerie : $error';
  }

  @override
  String get photoChoose => 'Choisir une photo';

  @override
  String get photoChange => 'Changer de photo';

  @override
  String get photoTapToChoose => 'Touchez pour choisir une photo';

  @override
  String get difficultyTitle => 'Difficulté';

  @override
  String get difficultyChoose => 'Choisissez un niveau';

  @override
  String createError(Object error) {
    return 'Impossible de créer le puzzle : $error';
  }

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyMaster => 'Maître';

  @override
  String get difficultyGrandMaster => 'Grand Maître';

  @override
  String get difficultyLegend => 'Légende';

  @override
  String get audienceEasy => 'Enfants, seniors, débutants';

  @override
  String get audienceMedium => 'Joueurs casual';

  @override
  String get audienceHard => 'Joueurs plus patients';

  @override
  String get audienceExpert => 'Joueurs aguerris';

  @override
  String get audienceMaster => 'Maîtres du puzzle';

  @override
  String get audienceGrandMaster => 'Experts confirmés';

  @override
  String get audienceLegend => 'Pour les légendes';

  @override
  String winsProgress(int count, int total) {
    return '$count / $total victoires';
  }

  @override
  String lockHint(int total, Object level) {
    return 'Gagnez $total parties en $level pour débloquer';
  }

  @override
  String get locked => 'Verrouillé';

  @override
  String get puzzlePreview => 'Aperçu';

  @override
  String get puzzlePause => 'Pause';

  @override
  String get puzzleResume => 'Reprendre';

  @override
  String get puzzleRestart => 'Recommencer';

  @override
  String get puzzlePaused => 'En pause';

  @override
  String get puzzleImageError => 'Erreur de chargement de l\'image';

  @override
  String puzzleTimeLimit(Object time) {
    return 'Limite : $time';
  }

  @override
  String get defeatTitle => 'Temps écoulé';

  @override
  String get defeatSubtitle =>
      'Le match est perdu. Réessayez, vous y êtes presque !';

  @override
  String get victoryTitle => 'Félicitations !';

  @override
  String get victorySubtitle => 'Souvenir complété.';

  @override
  String get statTime => 'Temps';

  @override
  String get statMoves => 'Mouvements';

  @override
  String get victoryNext => 'Suivant';

  @override
  String get victoryHome => 'Accueil';

  @override
  String get victoryNewMemory => 'Nouveau souvenir';

  @override
  String get levelUnlockTitle => 'Niveau débloqué !';

  @override
  String levelUnlockSubtitle(Object level) {
    return '$level est maintenant disponible.';
  }

  @override
  String get levelUnlockDismiss => 'Super !';

  @override
  String get memoriesTitle => 'Mes souvenirs';

  @override
  String memoriesCountTitle(int count) {
    return 'Mes souvenirs ($count)';
  }

  @override
  String get memoriesAdd => 'Ajouter des photos';

  @override
  String get memoriesPlay => 'Jouer';

  @override
  String memoriesLimitReached(int max) {
    return 'Limite de $max photos atteinte.';
  }

  @override
  String memoriesPartiallyAdded(int count, int max) {
    return '$count photo(s) ajoutée(s) — limite de $max atteinte.';
  }

  @override
  String memoriesAddError(Object error) {
    return 'Impossible d\'ajouter les photos : $error';
  }

  @override
  String get memoriesDeleteTitle => 'Supprimer ce souvenir ?';

  @override
  String get memoriesDeleteBody =>
      'Le puzzle et sa miniature seront supprimés. Votre photo d\'origine n\'est pas touchée.';

  @override
  String memoriesPlayedTimes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Joué $count fois',
      one: 'Joué 1 fois',
      zero: 'Jamais jouée',
    );
    return '$_temp0';
  }

  @override
  String get memoriesReadyToPlay => 'Photo prête à jouer';

  @override
  String get memoriesEmptyTitle => 'Aucun souvenir pour l\'instant';

  @override
  String get memoriesEmptyBody =>
      'Ajoutez vos photos, puis touchez « Jouer » pour un puzzle au hasard.';

  @override
  String get settingsSectionGame => 'Jeu';

  @override
  String get settingsSound => 'Son';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get settingsSectionPrivacy => 'Confidentialité';

  @override
  String get settingsPrivacyText =>
      'Votre vie privée compte. Souvenir Puzzle ne téléverse pas vos photos : tout reste sur votre téléphone.';

  @override
  String get settingsClearHistory => 'Effacer tous les souvenirs';

  @override
  String get settingsClearTitle => 'Effacer tous les souvenirs ?';

  @override
  String get settingsClearBody =>
      'Tous vos puzzles et leurs miniatures seront supprimés. Vos photos d\'origine ne sont pas touchées.';

  @override
  String get commonErase => 'Effacer';

  @override
  String get settingsCleared => 'Souvenirs effacés.';

  @override
  String errorPrefix(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Système';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageEnglish => 'English';

  @override
  String get navHome => 'Accueil';

  @override
  String get homePlay => 'Jouer';

  @override
  String get homeCurrentLevel => 'Niveau actuel';

  @override
  String homeLevelMatches(int current, int total) {
    return '$current / $total parties';
  }

  @override
  String homeUnlockNext(int current, int total, Object level) {
    return '$current / $total → $level';
  }

  @override
  String get homeLevelMax => 'Niveau maximum';

  @override
  String get homeResumeLastMatch => 'Finir le dernier match';

  @override
  String get homeWinsLabel => 'Victoires';

  @override
  String get homeUnlockLabel => 'Déblocage';

  @override
  String homeGridSize(int size) {
    return 'Grille $size×$size';
  }

  @override
  String get profilesTitle => 'Profils';

  @override
  String get profilesAdd => 'Ajouter un profil';

  @override
  String get profilesCreate => 'Créer le profil';

  @override
  String get profilesNameHint => 'Prénom ou pseudo';

  @override
  String get profilesActive => 'Profil actif';

  @override
  String get profilesChooseAvatar => 'Choisir une photo';

  @override
  String get profilesSwitch => 'Changer de profil';

  @override
  String get profilesEdit => 'Modifier';

  @override
  String get profilesEditTitle => 'Modifier le profil';

  @override
  String get profilesSave => 'Enregistrer';

  @override
  String get profilesDelete => 'Supprimer';

  @override
  String get profilesDeleteTitle => 'Supprimer ce profil ?';

  @override
  String get profilesDeleteBody =>
      'Tous les souvenirs, statistiques et progression de ce profil seront supprimés définitivement.';

  @override
  String get profilesDeleteLast => 'Impossible de supprimer le dernier profil.';

  @override
  String get playNeedsPhotos =>
      'Ajoutez d\'abord des photos dans Mes souvenirs.';

  @override
  String get menu => 'Menu';

  @override
  String get menuSectionPlay => 'Jouer';

  @override
  String get menuSectionProgress => 'Progression';

  @override
  String get menuSectionInfo => 'Informations';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutVision => 'Notre vision';

  @override
  String get aboutIntro =>
      'Souvenir Puzzle transforme vos photos en puzzles calmes et personnels. Chaque partie est une mémoire à reconstituer pièce par pièce — en famille, entre amis, ou pour vous-même.';

  @override
  String get aboutMission =>
      'Nous croyons que les photos de votre téléphone méritent mieux qu\'un album oublié. Ce jeu leur donne une seconde vie, douce et partageable, sans publicité ni compte obligatoire.';

  @override
  String get aboutHowItWorks => 'L\'expérience';

  @override
  String get aboutFeature1 =>
      'Ajoutez vos photos depuis la galerie — elles restent sur votre appareil.';

  @override
  String get aboutFeature2 =>
      'Choisissez un niveau, du Facile (3×3) à la Légende (9×9).';

  @override
  String get aboutFeature3 =>
      'Reconstituez l\'image en échangeant les pièces, à votre rythme.';

  @override
  String get aboutFeature4 =>
      'Aucune donnée personnelle n\'est envoyée en ligne : confidentialité totale.';

  @override
  String get aboutStudio => 'Studio';

  @override
  String get aboutStudioName => 'Koyra Games';

  @override
  String get aboutStudioTagline =>
      'Jeux calmes, émotionnels et accessibles à tous.';

  @override
  String get aboutStudioBody =>
      'Souvenir Puzzle est développé avec soin par un petit studio indépendant. Chaque mise à jour vise à rendre l\'expérience plus fluide, plus belle et plus chaleureuse.';

  @override
  String get aboutPrivacyTitle => 'Vie privée';

  @override
  String get aboutPrivacyBody =>
      'Vos photos et vos données restent sur votre appareil. Aucun compte n\'est requis. Vous pouvez effacer votre historique à tout moment depuis les paramètres.';

  @override
  String get aboutSupportTitle => 'Soutenir le projet';

  @override
  String get aboutSupportHeadline => 'Aimez-vous Souvenir Puzzle ?';

  @override
  String get aboutSupportIntro =>
      'Si ce jeu vous touche, vous pouvez m\'aider à le faire vivre : corrections, nouvelles fonctionnalités, traductions et maintenance prennent du temps.';

  @override
  String get aboutSupportWhy =>
      'Un petit geste — même modeste — permet de continuer à améliorer l\'application pour toute la communauté. Merci du fond du cœur.';

  @override
  String get aboutSupportThanks =>
      'Merci pour votre confiance et votre générosité. Chaque soutien compte.';

  @override
  String get aboutContactCta => 'Contact & support';

  @override
  String aboutVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get getStartedTitle => 'Commencer à jouer';

  @override
  String get getStartedIntro =>
      'Voici comment profiter de Souvenir Puzzle en quelques étapes.';

  @override
  String get getStartedStep1Title => 'Ajoutez vos photos';

  @override
  String get getStartedStep1Body =>
      'Dans Mes souvenirs, ajoutez une ou plusieurs photos depuis votre galerie.';

  @override
  String get getStartedStep2Title => 'Choisissez un niveau';

  @override
  String get getStartedStep2Body =>
      'Du Facile (3×3) à la Légende (9×9) — progressez en gagnant des parties.';

  @override
  String get getStartedStep3Title => 'Reconstituez l\'image';

  @override
  String get getStartedStep3Body =>
      'Glissez les pièces pour les échanger jusqu\'à retrouver votre souvenir.';

  @override
  String get getStartedStep4Title => 'Pause et victoire';

  @override
  String get getStartedStep4Body =>
      'Mettez en pause, consultez l\'image d\'origine, puis célébrez votre victoire.';

  @override
  String get getStartedCreatePuzzle => 'Créer mon premier puzzle';

  @override
  String get getStartedOpenMemories => 'Aller à Mes souvenirs';

  @override
  String get contactTitle => 'Contact & support';

  @override
  String get contactIntro =>
      'Une question, une idée, ou juste envie de dire bonjour ? Écrivez-moi — et si vous aimez Souvenir Puzzle, vous pouvez m\'offrir un café.';

  @override
  String get contactSectionContact => 'Contact';

  @override
  String get contactEmailLabel => 'Email';

  @override
  String get contactSectionCoffee => 'Offrez-moi un café';

  @override
  String get contactOrangeMoney => 'Orange Money';

  @override
  String get contactPaypal => 'PayPal';

  @override
  String get contactCopied => 'Copié dans le presse-papiers';

  @override
  String get contactCouldNotOpen => 'Impossible d\'ouvrir l\'application';

  @override
  String get statsTitle => 'Statistiques';

  @override
  String get statsMemories => 'Souvenirs';

  @override
  String get statsCompleted => 'Terminés';

  @override
  String get statsTotalTime => 'Temps total';

  @override
  String get statsTotalMoves => 'Coups au total';

  @override
  String get statsByLevel => 'Par niveau';

  @override
  String get statsBest => 'Meilleur';

  @override
  String get statsNoData => 'Jouez à un puzzle pour voir vos statistiques.';

  @override
  String get statsOverview => 'Vue d\'ensemble';

  @override
  String get statsActivityChart => 'Activité · 14 jours';

  @override
  String get statsActivitySubtitle => 'Puzzles terminés par jour';

  @override
  String get statsTimeTrend => 'Temps moyen · 14 jours';

  @override
  String get statsTimeTrendSubtitle => 'Durée moyenne par partie (min)';

  @override
  String get statsStreak => 'Série en cours';

  @override
  String statsStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: 'Aucune série',
    );
    return '$_temp0';
  }

  @override
  String get statsAvgSolve => 'Temps moyen';

  @override
  String get statsWinsPerDay => 'Victoires / jour';

  @override
  String get statsDifficultyBreakdown => 'Répartition par niveau';

  @override
  String get statsLevelDetails => 'Détail par niveau';

  @override
  String get statsPeriod7 => '7 j';

  @override
  String get statsPeriod14 => '14 j';

  @override
  String get statsPeriod30 => '30 j';

  @override
  String get statsInsights => 'Tendances';

  @override
  String get statsThisWeek => 'Cette semaine';

  @override
  String statsWeekChangeUp(int percent) {
    return '+$percent % vs sem. passée';
  }

  @override
  String statsWeekChangeDown(int percent) {
    return '$percent % vs sem. passée';
  }

  @override
  String get statsWeekChangeSame => 'Stable vs sem. passée';

  @override
  String get statsWeekChangeNew => 'Première semaine active';

  @override
  String get statsFavoriteLevel => 'Niveau favori';

  @override
  String get statsBestStreak => 'Meilleure série';

  @override
  String get statsActiveDays => 'Jours actifs';

  @override
  String get statsRegularity => 'Régularité';

  @override
  String get statsPeakDay => 'Meilleur jour';

  @override
  String statsPeakWins(int count) {
    return '$count parties';
  }

  @override
  String statsTotalInPeriod(int count) {
    return '$count parties sur la période';
  }

  @override
  String statsAvgPerDay(String avg) {
    return '$avg / jour en moyenne';
  }

  @override
  String get statsDistribution => 'Répartition';

  @override
  String get statsProgression => 'Progression';

  @override
  String get statsTapChartHint => 'Touchez le graphique pour les détails';
}
