import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_ints.dart';

// Riverpod provider for the controller
final pageNavigationProvider =
    StateNotifierProvider<PageNavigationController, ScreenData>((ref) {
  return PageNavigationController();
});

class PageNavigationController extends StateNotifier<ScreenData> {
  Map<int, dynamic> pageArguments = {};

  PageNavigationController()
      : super(ScreenData(currentPage: 0, screensTrack: [0]));

  dynamic getArgumentsForPage(int index) {
    if (index == AppInts.examsPageIndex) {
      return pageArguments[index] as int;
    }
    if (index == AppInts.courseChaptersPageIndex) {
      return pageArguments[index] as Map<String, dynamic>;
    }
    if (index == AppInts.examQuestionsPageIndex) {
      return pageArguments[index] as Map<String, dynamic>;
    }

    if (index == AppInts.examCoursesFiltersPageIndex) {
      var arg = pageArguments[index];
      arg ??= "Exam Title";
      return arg;
    }
    if (index == AppInts.examGradeFilterPageIndex) {
      debugPrint("index argument is 8");
      return pageArguments[index] as Map<String, dynamic>;
    }
    return null;
  }

  void navigateBack() {
    List<int> newScreens = List.from(state.screensTrack);
    if (newScreens.isNotEmpty) {
      newScreens.removeLast();
    }
    debugPrint("screens: [${newScreens.map((s) => "back $s").join(",")}]");
    state = state.copyWith(scrs: newScreens, currentScreen: newScreens.last);
  }

  void navigateTo({required int nextScreen, dynamic arguments}) {
    if (arguments != null) {
      pageArguments[nextScreen] = arguments;
    }
    List<int> newScreens = List.from(state.screensTrack);

    // if (newScreens.isNotEmpty && newScreens.last == nextScreen) {
    //   return;
    // }
    // if (newScreens.length == 2) {
    //   newScreens.removeAt(0);
    // }
    newScreens.add(nextScreen);
    debugPrint("screens: [${newScreens.map((s) => "forward $s").join(",")}]");
    state = state.copyWith(scrs: newScreens, currentScreen: nextScreen);
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
