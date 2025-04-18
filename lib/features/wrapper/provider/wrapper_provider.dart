import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, int>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<int> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController() : super(0);

  dynamic getArgumentsForPage(int index) {
    if (index == 3) {
      return pageArguments[index] as int;
    }

    if (index == 6) {
      return pageArguments[index] as Map<String, dynamic>;
    }

    if (index == 5) {
      return pageArguments[index] as Map<String, dynamic>;
    }

    if (index == 7) {
      var arg = pageArguments[index];
      arg ??= "Exam Title";
      return arg;
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
