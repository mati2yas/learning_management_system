class ScoreValue {
  final int attemptedQuestions;
  final int totalQuestions;
  final int score;
  const ScoreValue({
    required this.attemptedQuestions,
    required this.totalQuestions,
    required this.score,
  });

  ScoreValue copyWith({
    int? attemptedQuestions,
    int? totalQuestions,
    int? score,
  }) {
    return ScoreValue(
      attemptedQuestions: attemptedQuestions ?? this.attemptedQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      score: score ?? this.score,
    );
  }

  ScoreValue initial() {
    return const ScoreValue(
      attemptedQuestions: 0,
      totalQuestions: 0,
      score: 0,
    );
  }
}