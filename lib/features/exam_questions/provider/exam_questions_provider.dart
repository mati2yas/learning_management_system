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
  @override
  Future<List<Question>> build() {
    return fetchQuestions();
  }

  Future<List<Question>> fetchQuestions() async {
    var currentIdStub = ref.read(currentIdStubProvider);
    debugPrint("State set to AsyncLoading()");
    state = const AsyncValue.loading();
    try {
      final questions =
          await _repository.fetchQuestionsByGenericId(currentIdStub);
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
