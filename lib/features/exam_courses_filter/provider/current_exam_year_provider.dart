import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentExamYearIdProvider =
    StateNotifierProvider<CurrentExamYearIdController, int>((ref) {
  return CurrentExamYearIdController();
});

class CurrentExamYearIdController extends StateNotifier<int> {
  CurrentExamYearIdController() : super(0);
  void changeYearId(int yearId) {
    //debugPrint("change year id to: $yearId");
    state = yearId;
  }
}
