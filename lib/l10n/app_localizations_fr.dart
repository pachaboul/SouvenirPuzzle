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
  String get audienceEasy => 'Enfants, seniors, débutants';

  @override
  String get audienceMedium => 'Joueurs casual';

  @override
  String get audienceHard => 'Joueurs plus patients';

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
  String get victoryNewMemory => 'Nouveau souvenir';

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
  String get playNeedsPhotos =>
      'Ajoutez d\'abord des photos dans Mes souvenirs.';

  @override
  String get menu => 'Menu';

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
}
