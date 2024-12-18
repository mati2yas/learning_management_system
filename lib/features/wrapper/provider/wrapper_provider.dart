import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';

import '../../exams/model/exams_model.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, int>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<int> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController() : super(0);

  dynamic getArgumentsForPage(int index) {
    if (index == 5) {
      return pageArguments[index] as CourseCategory?;
    }

    if (index == 6) {
      return pageArguments[index] as Map<String, dynamic>;
    }

    if (index == 7) {
      return pageArguments[index] as Exam;
    }
    if (index == 8) {
      print("index argument is 8");
      return pageArguments[index] as Map<String, dynamic>;
    }
    return null;
  }

  void navigatePage(int index, {dynamic arguments}) {
    if (arguments != null) {
      pageArguments[index] = arguments;
    }
    state = index;
  }
}
