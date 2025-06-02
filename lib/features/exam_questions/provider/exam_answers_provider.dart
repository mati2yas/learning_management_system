import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/answers_holder.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/score_management.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/score_value.dart';

final examAnswersProvider =
    StateNotifierProvider<AnswersNotifier, ScoreManagement>(
  (ref) => AnswersNotifier(),
);

class AnswersNotifier extends StateNotifier<ScoreManagement> {
  AnswersNotifier() : super(ScoreManagement.initial());
  void getScore() {
    int score = 0;
    int attempted = 0;
    for (var answerHolder in state.answersHolders) {
      if (answerHolder.selectedAnswers.isNotEmpty) {
        attempted++;
        List correctListCurrentQuestion = answerHolder.correctAnswers;
        List selectedListCurrentQuestion =
            answerHolder.selectedAnswers.toList();
        if (correctListCurrentQuestion.length == 1 &&
            correctListCurrentQuestion[0] == selectedListCurrentQuestion[0]) {
          //debugPrint("sigle answer case, selected answer is correct");
          score++;
          continue;
        }
        List<String> incorrectAnswers = answerHolder.options
            .where((op) => !answerHolder.correctAnswers.contains(op))
            .toList();
        bool containsSomeWrong = false;

        for (var incorrect in incorrectAnswers) {
          if (answerHolder.selectedAnswers.contains(incorrect)) {
            containsSomeWrong = true;
          }
        }

        bool containsAllRight = correctListCurrentQuestion
                .every((ans) => selectedListCurrentQuestion.contains(ans)) &&
            !containsSomeWrong;
        if (containsAllRight) {
          debugPrint(
              "multi answer case, selected answers include all correct answers.");
          score++;
          continue;
        }
      }
    }

    debugPrint(
        "is score higher than attempted? score $score vs attempted $attempted");

    var scr = state.scoreValue;
    scr = scr.copyWith(
      score: score,
      attemptedQuestions: attempted,
    );
    state = state.copyWith(scoreValue: scr);
  }

  void initializeWithQuestionsList(List<Question> questionsList) {
    List<AnswersHolder> answerHolders = questionsList
        .map(
          (question) => AnswersHolder(
            options: question.options,
            questionId: question.id,
            correctAnswers: question.answers,
          ),
        )
        .toList();
    int totalQuestions = questionsList.length;

    var scrV = ScoreValue(
        attemptedQuestions: 0, totalQuestions: totalQuestions, score: 0);
    state = state.copyWith(
      scoreValue: scrV,
      answersHolders: answerHolders,
    );
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

    var ansHold = state.answersHolders.map((answerHolder) {
      if (answerHolder.questionId == qn.id) {
        Set<String> newSelectedAnswers = {...answerHolder.selectedAnswers};

        if (answerHolder.correctAnswers.length == 1) {
          //debugPrint("in provider page, inside single answer case");
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
          //debugPrint("in provider page, inside multi answer case");

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
        //debugPrint("after manipulation: set {${newSelectedAnswers.join(",")}}");
        return answerHolder;
      }

      return answerHolder;
    }).toList();

    state = state.copyWith(answersHolders: ansHold);
    getScore();
  }
}
