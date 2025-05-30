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
      : super(
            ScreenData(currentPage: 0, screensTrack: [AppInts.homePageIndex]));

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
    if (index == AppInts.examChapterFilterPageIndex) {
      debugPrint("index argument is 9");
      return pageArguments[index] as Map<String, dynamic>;
    }
    return null;
  }

  void navigateBack() {
    List<int> newScreens = List.from(state.screensTrack);
    if (newScreens.length > 1) {
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
    if (state.homeScreensData.contains(nextScreen)) {
      newScreens = [nextScreen];

      // this should ensure the list always starts with
      // one of the home screens.
      // in one of the cases we allow 2 of the home screens
      // to be visible
    }

    if (!newScreens.contains(nextScreen)) {
      newScreens.add(nextScreen);
    }
    debugPrint("screens: [${newScreens.map((s) => "forward $s").join(",")}]");
    state = state.copyWith(scrs: newScreens, currentScreen: nextScreen);
  }
}

class ScreenData {
  final List<int> screensTrack;
  List<int> homeScreensData;
  final int currentPage;
  ScreenData({
    this.screensTrack = const [],
    this.homeScreensData = const [
      AppInts.homePageIndex,
      AppInts.coursePageIndex,
      AppInts.examsPageIndex,
      AppInts.paidPageIndex,
    ],
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
