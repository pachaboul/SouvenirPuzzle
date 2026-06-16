/// Best result for one session at one difficulty level.
class BestScore {
  const BestScore({
    required this.timeSeconds,
    required this.moves,
    required this.plays,
  });

  final int timeSeconds;
  final int moves;
  final int plays;
}
