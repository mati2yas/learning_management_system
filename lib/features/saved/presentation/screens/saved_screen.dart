import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/saved/provider/saved_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../widgets/courses_list.dart';

class SavedCoursesPage extends ConsumerStatefulWidget {
  const SavedCoursesPage({super.key});

  @override
  ConsumerState<SavedCoursesPage> createState() => _SavedCoursesPageState();
}

class _SavedCoursesPageState extends ConsumerState<SavedCoursesPage> {
  List<String> categories = ["All", "University", "High School", "Lower Grade"];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    final pageController = ref.read(pageNavigationProvider.notifier);
    final savedApiState = ref.watch(savedApiProvider);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Saved Courses"),
          centerTitle: true,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
        ),
        body: savedApiState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
          error: (error, stack) => AsyncErrorWidget(
            errorMsg: error.toString(),
            callback: () async {
              ref.watch(savedApiProvider.notifier).fetchSavedCoursesData();
            },
          ),
          data: (courses) {
            return CoursesListWidget(
              courses: courses,
              textTh: textTh,
            );
          },
        ),
      ),
    );
  }
}
