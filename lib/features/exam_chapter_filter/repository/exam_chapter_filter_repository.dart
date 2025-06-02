import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/exam_chapter_filter/data_source/exam_chapter_filter_datasource.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examChapterFilterRepositoryProvider =
    Provider<ExamChapterFilterRepository>((ref) {
  return ExamChapterFilterRepository(
    ref.watch(examChapterFilterDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ExamChapterFilterRepository {
  final ExamChapterFilterDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ExamChapterFilterRepository(this._dataSource, this._connectivityService);

  Future<List<ExamChapter>> fetchExamChapters({
    required int yearId,
    required int courseId,
  }) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchExamChapters(yearId: yearId, courseId: courseId);
  }
}
