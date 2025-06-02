import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exam_chapter_filter/repository/exam_chapter_filter_repository.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';

final examChapterFilterApiProvider =
    AsyncNotifierProvider<ExamChapterFilterNotifier, List<ExamChapter>>(
  () {
    final container = ProviderContainer(
      overrides: [
        examChapterFilterRepositoryProvider,
      ],
    );
    return container.read(examChapterFilterNotifierProvider);
  },
);
final examChapterFilterNotifierProvider = Provider((ref) =>
    ExamChapterFilterNotifier(ref.read(examChapterFilterRepositoryProvider)));

class ExamChapterFilterNotifier extends AsyncNotifier<List<ExamChapter>> {
  final ExamChapterFilterRepository _repository;

  ExamChapterFilterNotifier(this._repository);
  @override
  Future<List<ExamChapter>> build() {
    return fetchExamChapters();
  }

  Future<List<ExamChapter>> fetchExamChapters() async {
    int yearId = ref.read(currentExamYearIdProvider);
    int courseId = ref.read(currentExamCourseIdProvider);
    state = const AsyncValue.loading();
    try {
      final examChapters = await _repository.fetchExamChapters(yearId: yearId, courseId: courseId);
      state = AsyncValue.data(examChapters);
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
    return state.value ?? [];
  }
}
