import '../features/puzzle/domain/puzzle_difficulty.dart';
import 'app_localizations.dart';

/// Localized label/audience for a [PuzzleDifficulty].
extension DifficultyL10n on PuzzleDifficulty {
  String label(AppLocalizations l) {
    switch (this) {
      case PuzzleDifficulty.easy:
        return l.difficultyEasy;
      case PuzzleDifficulty.medium:
        return l.difficultyMedium;
      case PuzzleDifficulty.hard:
        return l.difficultyHard;
    }
  }

  String audience(AppLocalizations l) {
    switch (this) {
      case PuzzleDifficulty.easy:
        return l.audienceEasy;
      case PuzzleDifficulty.medium:
        return l.audienceMedium;
      case PuzzleDifficulty.hard:
        return l.audienceHard;
    }
  }
}
