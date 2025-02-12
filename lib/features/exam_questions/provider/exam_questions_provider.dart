import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_questions/provider/answers_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/repository/exam_questions_repository.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examQuestionsApiProvider =
    AsyncNotifierProvider<ExamQuestionsNotifier, List<Question>>(
  () {
    final container = ProviderContainer(
      overrides: [
        examQuestionsRepositoryProvider,
      ],
    );
    return container.read(examQuestionsNotitifierProvider);
  },
);

final examQuestionsNotitifierProvider = Provider(
  (ref) => ExamQuestionsNotifier(ref.read(examQuestionsRepositoryProvider)),
);

class ExamQuestionsNotifier extends AsyncNotifier<List<Question>> {
  final ExamQuestionsRepository _repository;
  ExamQuestionsNotifier(this._repository);
  List<Question> addExtraAnswerToRandomQuestions(List<Question> questions) {
    // generate n / 5 random integers between
    // 0 and length of our list.
    var rand = Random();
    int maxNumOfRandoms = questions.length ~/ 4;
    List<int> randomIndices = [];
    for (int i = 0; i < maxNumOfRandoms; i++) {
      randomIndices.add(rand.nextInt(questions.length));
    }
    for (int i = 0; i < questions.length; i++) {
      if (i != 0) {
        debugPrint(
            "question $i options: [ ${questions[i].options.join(",")} ]");
        debugPrint(
            "question $i answers: [ ${questions[i].answers.join(",")} ]");
      }
      if (!randomIndices.contains(i)) continue;
      List<String> newAns = questions[i].answers;
      if (newAns.length == 1) {
        for (var op in questions[i].options) {
          if (!questions[i].answers.contains(op)) {
            questions[i].answers.add(op);
          }
        }
      }
    }
    debugPrint("questions length after manipulation: ${questions.length}");
    return questions;
  }

  @override
  Future<List<Question>> build() {
    return fetchQuestions();
  }

  Future<List<Question>> fetchQuestions() async {
    var currentIdStub = ref.read(currentIdStubProvider);
    debugPrint("State set to AsyncLoading()");
    state = const AsyncValue.loading();
    try {
      List<Question> questions =
          await _repository.fetchQuestionsByGenericId(currentIdStub);
      debugPrint(
          "questions length right before manipulation: ${questions.length}");
      questions = addExtraAnswerToRandomQuestions(questions);
      debugPrint("Fetched questions type: ${questions.runtimeType}");

      final answersController = ref.watch(answersProvider.notifier);
      answersController.initializeWithQuestionsList(questions);
      state = AsyncValue.data(questions);

      return questions;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
