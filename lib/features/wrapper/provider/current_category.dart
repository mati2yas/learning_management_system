import 'package:riverpod/riverpod.dart';

final currentCategoryProvider =
    StateNotifierProvider<CurrentCategoryController, String>((ref) {
  return CurrentCategoryController();
});

class CurrentCategoryController extends StateNotifier<String> {
  CurrentCategoryController() : super("lower_grades");
  void changeCategory(String category) {
    state = category;
  }
}
