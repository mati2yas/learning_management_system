import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/quiz/provider/current_quiz_id_provider.dart';
import 'package:lms_system/features/quiz/provider/quiz_answers_provider.dart';
import 'package:lms_system/features/quiz/provider/quiz_repository_provider.dart';
import 'package:lms_system/features/quiz/repository/quiz_repository.dart';

import '../model/quiz_model.dart';

final quizDataNotifierProvider = Provider((ref) {
  return QuizNotifier(ref.watch(quizRepositoryProvider));
});

final quizProvider = AsyncNotifierProvider<QuizNotifier, Quiz>(() {
  final container = ProviderContainer(
    overrides: [quizRepositoryProvider],
  );
  return container.read(quizDataNotifierProvider);
});

class QuizNotifier extends AsyncNotifier<Quiz> {
  final QuizRepository _repository;
  QuizNotifier(this._repository);

  @override
  FutureOr<Quiz> build() {
    return fetchQuizData();
  }

  Future<Quiz> fetchQuizData() async {
    final quizId = ref.read(currentQuizIdProvider);
    state = const AsyncValue.loading();

    try {
      debugPrint("quiz id: $quizId");
      final quiz = await _repository.fetchQuizData(quizId);
      final answersController = ref.watch(quizAnswersProvider.notifier);
      answersController.initializeWithQuestionsList(quiz.questions);
      state = AsyncData(quiz);
      return quiz;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
