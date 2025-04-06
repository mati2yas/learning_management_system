import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/paid_courses_exams/data_source/paid_exams_datasource.dart';
import 'package:lms_system/features/paid_courses_exams/model/paid_exam_model.dart';

final paidExamsRepositoryProvider = Provider<PaidExamsRepository>((ref) {
  return PaidExamsRepository(
    ref.watch(paidExamsDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class PaidExamsRepository {
  final PaidExamsDataSource _dataSource;
  final ConnectivityService _connectivityService;

  PaidExamsRepository(this._dataSource, this._connectivityService);

  Future<List<PaidExam>> fetchPaidExams() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return _dataSource.fetchPaidExams();
  }
}
