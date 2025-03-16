import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/home/repository/home_repository.dart';
import 'package:lms_system/features/paid_courses_exams/model/paid_exam_model.dart';
import 'package:lms_system/features/paid_courses_exams/repository/paid_exam_repository.dart';

final paidExamsApiNotifierProvider =
    Provider((ref) => PaidExamsNotifier(ref.read(paidExamsRepositoryProvider)));

final paidExamsApiProvider =
    AsyncNotifierProvider<PaidExamsNotifier, List<PaidExam>>(
  () {
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider,
      ],
    );
    return container.read(paidExamsApiNotifierProvider);
  },
);

class PaidExamsNotifier extends AsyncNotifier<List<PaidExam>> {
  final PaidExamsRepository _repository;

  PaidExamsNotifier(this._repository);

  @override
  Future<List<PaidExam>> build() async {
    // Fetch and return the initial data
    return fetchPaidExams();
  }

  Future<List<PaidExam>> fetchPaidExams() async {
    try {
      final courses = await _repository.fetchPaidExams();
      return courses; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
