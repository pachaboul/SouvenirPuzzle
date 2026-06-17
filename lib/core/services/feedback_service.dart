import 'package:flutter/services.dart';

/// Light sound + haptic feedback, gated by the user's settings.
///
/// Uses only built-in platform feedback (no audio assets / dependencies):
/// [SystemSound] for a soft click and [HapticFeedback] for vibration. Both are
/// no-ops on platforms that don't support them (e.g. desktop).
class FeedbackService {
  const FeedbackService({
    required this.soundEnabled,
    required this.vibrationEnabled,
  });

  final bool soundEnabled;
  final bool vibrationEnabled;

  /// Called when a piece is moved/swapped.
  void pieceMoved() {
    if (soundEnabled) SystemSound.play(SystemSoundType.click);
    if (vibrationEnabled) HapticFeedback.selectionClick();
  }

  /// Called when the puzzle is solved.
  void victory() {
    if (soundEnabled) SystemSound.play(SystemSoundType.alert);
    if (vibrationEnabled) HapticFeedback.mediumImpact();
  }
}
