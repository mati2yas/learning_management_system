import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final answersProvider =
    StateNotifierProvider<AnswersNotifier, List<AnswersHolder>>(
  (ref) => AnswersNotifier(),
);

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

  AnswersHolder emptyTheAnswers(String previousAnswer) {
    // we know this method is called when a radio button
    // gives us empty option.
    // so we use it to empty the answers list
    // but if the list already had some thing in it, we don't
    // want to empty it. so in that case we preserve the list
    // next time when that answer is unselected, it will empty the list.
    if (selectedAnswers.contains(previousAnswer)) {
      debugPrint(
          "Set: { ${selectedAnswers.join(",")} contains previous value: $previousAnswer }");
      selectedAnswers = {};
      // empty the list because the unselected value is our previous value
    }
    return AnswersHolder(
      questionId: questionId,
      correctAnswers: correctAnswers,
      selectedAnswers: selectedAnswers,
    );
  }
}

class AnswersNotifier extends StateNotifier<List<AnswersHolder>> {
  AnswersNotifier() : super([]);
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
