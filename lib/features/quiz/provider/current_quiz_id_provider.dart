import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentQuizIdProvider =
    StateNotifierProvider<CurrentQuizIdController, String>((ref) {
  return CurrentQuizIdController();
});

class CurrentQuizIdController extends StateNotifier<String> {
  CurrentQuizIdController() : super("0");
  void changeQuizId(String newId) {
    state = newId;
  }
}
