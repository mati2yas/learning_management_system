import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

final currentExamTypeProvider =
    StateNotifierProvider<CurrentExamTypeNotifier, ExamType>((ref) {
  return CurrentExamTypeNotifier();
});

class CurrentExamTypeNotifier extends StateNotifier<ExamType> {
  CurrentExamTypeNotifier() : super(ExamType.matric);

  void changeExamType(ExamType newType) {
    state = newType;
  }
}
