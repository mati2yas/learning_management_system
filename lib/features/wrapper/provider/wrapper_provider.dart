import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, int>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<int> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController() : super(0);

  dynamic getArgumentsForPage(int index) => pageArguments[index];

  void navigatePage(int index, {dynamic arguments}) {
    if (arguments != null) {
      pageArguments[index] = arguments;
    }
    state = index;
  }
}
