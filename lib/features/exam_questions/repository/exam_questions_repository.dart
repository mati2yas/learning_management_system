import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/exam_questions/data_source/exam_questions_data_source.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final examQuestionsRepositoryProvider =
    Provider<ExamQuestionsRepository>((ref) {
  return ExamQuestionsRepository(
    ref.watch(examQuestionsDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ExamQuestionsRepository {
  final ExamQuestionsDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ExamQuestionsRepository(this._dataSource, this._connectivityService);

  Future<List<Question>> fetchQuestionsByChapterId(
      {required int chapterId, required int gradeId}) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchQuestionsByChapterId(
        chapterId: chapterId, gradeId: gradeId);
  }

  Future<List<Question>> fetchQuestionsByGenericId(
      Map<String, dynamic> idStub) async {
    // we have to know which function to call.
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    if (idStub[AppStrings.stubIdType] == IdType.filtered) {
      return await _dataSource.fetchQuestionsByChapterId(
          chapterId: idStub[AppStrings.stubId]!,
          gradeId: idStub[AppStrings.stubGradeId]!);
    } else if (idStub[AppStrings.stubIdType] == IdType.all) {
      List<Question> questions = await _dataSource.fetchQuestionsByYearId(
          idStub[AppStrings.stubId]!, idStub[AppStrings.stubCourseId]!);

      return questions;
    }
    return [];
  }

  Future<List<Question>> fetchQuestionsByYearId(
      int yearId, int courseId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.fetchQuestionsByYearId(yearId, courseId);
  }
}
