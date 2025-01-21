import 'package:lms_system/features/courses/data_source/course_detail_data_source.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';
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
