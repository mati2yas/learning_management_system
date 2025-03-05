import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/shared/model/answers_holder.dart';

final examAnswersProvider =
    StateNotifierProvider<AnswersNotifier, List<AnswersHolder>>(
  (ref) => AnswersNotifier(),
);

class AnswersNotifier extends StateNotifier<List<AnswersHolder>> {
  AnswersNotifier() : super([]);
  int getScore() {
    int score = 0;
    for (var answerHolder in state) {
      List correctListCurrentQuestion = answerHolder.correctAnswers;
      List selectedListCurrentQuestion = answerHolder.selectedAnswers.toList();
      if (correctListCurrentQuestion.length == 1 &&
          correctListCurrentQuestion[0] == selectedListCurrentQuestion[0]) {
        debugPrint("sigle answer case, selected answer is correct");
        score++;
        continue;
      }
      bool containsAll = correctListCurrentQuestion
          .every((ans) => selectedListCurrentQuestion.contains(ans));
      if (containsAll) {
        debugPrint(
            "multi answer case, selected answers include all correct answers.");
        score++;
        continue;
      }
    }
    return score;
  }

  void initializeWithQuestionsList(List<Question> questionsList) {
    state = questionsList
        .map((question) => AnswersHolder(
            questionId: question.id, correctAnswers: question.answers))
        .toList();
    debugPrint("answerHolder state length: ${state.length}");
  }

  void selectAnswerForQuestion({
    required Question qn,
    String? selectedAnswer,
    required String radioButtonValue,
  }) {
    // selectedAnswer will be empty in case where
    // the option type is radio list and all radio are unselected.
    // the radio buttons go on a loop to call either the
    // copyWith method in case they have a non-null value,
    // or emptyList in case they have null value.
    state = state.map((answerHolder) {
      if (answerHolder.questionId == qn.id) {
        Set<String> newSelectedAnswers = {...answerHolder.selectedAnswers};

        if (answerHolder.correctAnswers.length == 1) {
          debugPrint("in provider page, inside single answer case");
          if (selectedAnswer == null) {
          } else if (newSelectedAnswers.contains(radioButtonValue)) {
            debugPrint(
                "set {${newSelectedAnswers.join(",")}} contains $selectedAnswer");
            newSelectedAnswers.remove(radioButtonValue);
          } else {
            debugPrint(
                "set {${newSelectedAnswers.join(",")}} does not contain $selectedAnswer");
            newSelectedAnswers = {selectedAnswer};
          }
        } else {
          debugPrint("in provider page, inside multi answer case");

          debugPrint(
              "set {${answerHolder.selectedAnswers.join(",")}} contains $radioButtonValue?");
          if (selectedAnswer == null) {
            if (answerHolder.selectedAnswers.contains(radioButtonValue)) {
              debugPrint(
                  "set {${answerHolder.selectedAnswers.join(",")}} contains $radioButtonValue");
              newSelectedAnswers.remove(radioButtonValue);
            }
          } else if (answerHolder.selectedAnswers.contains(radioButtonValue)) {
            debugPrint(
                "set {${answerHolder.selectedAnswers.join(",")}} contains $radioButtonValue");
            newSelectedAnswers.remove(radioButtonValue);
          } else {
            debugPrint(
                "set {${answerHolder.selectedAnswers.join(",")}} does not contain $selectedAnswer");
            newSelectedAnswers.add(selectedAnswer);
          }
        }
        answerHolder =
            answerHolder.copyWith(selectedAnswers: newSelectedAnswers);
        debugPrint("after manipulation: set {${newSelectedAnswers.join(",")}}");
        return answerHolder;
      }

      return answerHolder;
    }).toList();
  }
}
