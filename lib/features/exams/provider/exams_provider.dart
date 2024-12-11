import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/data_source/exams_data_source.dart';

import '../model/exams_model.dart';

final examsDataSourceProvider = Provider<ExamsDataSource>((ref) {
  return ExamsDataSource();
});
final examsProvider = StateNotifierProvider<ExamsNotifier, List<Exam>>((ref) {
  final dataSource = ref.read(examsDataSourceProvider);
  return ExamsNotifier(dataSource);
});

class ExamsNotifier extends StateNotifier<List<Exam>> {
  final ExamsDataSource dataSource;
  ExamsNotifier(this.dataSource) : super([]) {
    loadExams();
  }

  void loadExams() {
    state = dataSource.fetchExams();
  }
}
