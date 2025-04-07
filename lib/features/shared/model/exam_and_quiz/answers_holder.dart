class AnswersHolder {
  final int questionId;
  List<String> correctAnswers;
  List<String> options;
  Set<String> selectedAnswers;
  AnswersHolder({
    required this.questionId,
    this.correctAnswers = const [],
    this.options = const [],
    this.selectedAnswers = const {},
  });

  AnswersHolder copyWith({
    List<String>? correctAnswer,
    List<String>? options,
    String? selectedAnswer,
    Set<String>? selectedAnswers,
  }) {
    // Set<String> answersList = selectedAnswers;
    // if (selectedAnswer != null && !answersList.contains(selectedAnswer)) {
    //   answersList.add(selectedAnswer);
    // }

    return AnswersHolder(
      questionId: questionId,
      correctAnswers: correctAnswer ?? correctAnswers,
      options: options ?? this.options,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}
