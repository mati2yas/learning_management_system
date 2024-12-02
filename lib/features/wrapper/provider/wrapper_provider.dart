import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, int>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<int> {
  PageNavigationController() : super(0);

  void goBackToPreviousPage(int previousPage) => state = previousPage;

  void navigatePage(int page) => state = page;

  void resetToHome() => state = 0;
}
