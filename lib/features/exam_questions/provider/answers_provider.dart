import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final answersProvider =
    StateNotifierProvider<AnswersNotifier, List<AnswersHolder>>(
  (ref) => AnswersNotifier(),
);

class AnswersHolder {
  final int questionId;
  String correctAnswer;
  String selectedAnswer;
  AnswersHolder({
    required this.questionId,
    this.correctAnswer = "",
    this.selectedAnswer = "",
  });

  AnswersHolder copyWith({String? correctAnswer, String? selectedAnswer}) {
    return AnswersHolder(
      questionId: questionId,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
    );
  }
}

class AnswersNotifier extends StateNotifier<List<AnswersHolder>> {
  AnswersNotifier() : super([]);
  void initializeWithQuestionsList(List<Question> questionsList) {
    state = questionsList
        .map((question) => AnswersHolder(
            questionId: question.id, correctAnswer: question.answer))
        .toList();
  }

  void selectAnswerForQuestion(Question qn, String selectedAnswer) {
    state = state.map((answerHolder) {
      if (answerHolder.questionId == qn.id) {
        return answerHolder.copyWith(selectedAnswer: selectedAnswer);
      }
      return answerHolder;
    }).toList();
  }
}
