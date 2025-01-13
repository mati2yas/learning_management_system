import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingController extends StateNotifier<int> {
  final PageController pageController = PageController();

  OnboardingController() : super(0);

  void setPage(int page) {
    state = page;
    pageController.jumpToPage(page);
  }

  void nextPage() {
    if (state < 2) {
      state++;
      pageController.jumpToPage(state);
    }
  }

  void skipToLastPage() {
    state = 2;
    pageController.jumpToPage(2);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingController, int>((ref) {
  return OnboardingController();
});
