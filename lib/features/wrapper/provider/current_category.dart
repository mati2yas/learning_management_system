import 'package:lms_system/features/courses/data_source/course_detail_data_source.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';
import 'package:riverpod/riverpod.dart';

final currentCategoryProvider =
    StateNotifierProvider<CurrentCategoryController, CourseCategory>((ref) {
  return CurrentCategoryController();
});

class CurrentCategoryController extends StateNotifier<CourseCategory> {
  CurrentCategoryController() : super(categoriesData[0]);
  void changeCategory(CategoryType catType) {
    state = categoriesData.firstWhere((cData) => cData.categoryType == catType);
  }
}
