import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';

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
