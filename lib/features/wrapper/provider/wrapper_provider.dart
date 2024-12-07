import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, int>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<int> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController() : super(0);

  CourseCategory? getArgumentsForPage(int index) {
    if (pageArguments.containsKey(index)) {
      return pageArguments[index] as CourseCategory?;
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
