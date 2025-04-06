class AnswersHolder {
  final int questionId;
  List<String> correctAnswers;
  Set<String> selectedAnswers;
  AnswersHolder({
    required this.questionId,
    this.correctAnswers = const [],
    this.selectedAnswers = const {},
  });

  AnswersHolder copyWith({
    List<String>? correctAnswer,
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
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }
}




