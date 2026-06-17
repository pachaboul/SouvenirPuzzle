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
      case PuzzleDifficulty.expert:
        return l.difficultyExpert;
      case PuzzleDifficulty.master:
        return l.difficultyMaster;
      case PuzzleDifficulty.grandMaster:
        return l.difficultyGrandMaster;
      case PuzzleDifficulty.legend:
        return l.difficultyLegend;
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
      case PuzzleDifficulty.expert:
        return l.audienceExpert;
      case PuzzleDifficulty.master:
        return l.audienceMaster;
      case PuzzleDifficulty.grandMaster:
        return l.audienceGrandMaster;
      case PuzzleDifficulty.legend:
        return l.audienceLegend;
    }
  }
}
