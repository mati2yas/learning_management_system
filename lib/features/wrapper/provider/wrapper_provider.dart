import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, ScreenData>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<ScreenData> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController() : super(ScreenData(currentPage: 0));

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
      debugPrint("index argument is 8");
      return pageArguments[index] as Map<String, dynamic>;
    }
    return null;
  }

  void navigateBack() {
    List<int> scs = List.from(state.screensTrack);
    scs.removeLast();
    debugPrint("screens: [${scs.map((s) => "back $s").join(",")}]");
    state = state.copyWith(scrs: scs, currentScreen: scs.last);
  }

  void navigateTo({required int nextScreen, dynamic arguments}) {
    if (arguments != null) {
      pageArguments[nextScreen] = arguments;
    }
    List<int> scs = List.from(state.screensTrack);
    scs.add(nextScreen);
    debugPrint("screens: [${scs.map((s) => "forward $s").join(",")}]");
    state = state.copyWith(scrs: scs, currentScreen: nextScreen);
  }
}

class ScreenData {
  final List<int> screensTrack;
  final int currentPage;
  ScreenData({
    this.screensTrack = const [],
    required this.currentPage,
  });

  ScreenData copyWith({
    int? currentScreen,
    List<int>? scrs,
  }) {
    return ScreenData(
      screensTrack: scrs ?? screensTrack,
      currentPage: currentScreen ?? currentPage,
    );
  }
}
