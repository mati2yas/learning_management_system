import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<List<Question>> fetchQuestionsByGenericId(
      Map<String, dynamic> idStub) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    // we have to know which function to call.
    late Function fetchFunction;
    if (idStub["idType"] == IdType.filtered) {
      fetchFunction = _dataSource.fetchQuestionsByChapterId;
    } else if (idStub["idType"] == IdType.all) {
      fetchFunction = _dataSource.fetchQuestiosnByYearId;
    }
    return await fetchFunction(idStub["id"]!);
  }
}
