import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentChapterIdProvider =
    StateNotifierProvider<CurrentChapterIdController, String>((ref) {
  return CurrentChapterIdController();
});

class CurrentChapterIdController extends StateNotifier<String> {
  CurrentChapterIdController() : super("0");
  void changeChapterId(String newId) {
    state = newId;
  }
}
