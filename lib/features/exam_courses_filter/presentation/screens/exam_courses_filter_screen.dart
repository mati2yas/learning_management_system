import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exam_courses_filter/presentation/widgets/years_list.dart';
import 'package:lms_system/features/exam_courses_filter/provider/exam_courses_filter_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamCoursesFiltersScreen extends ConsumerStatefulWidget {
  const ExamCoursesFiltersScreen({
    super.key,
  });

  @override
  ConsumerState<ExamCoursesFiltersScreen> createState() =>
      _ExamCoursesFilterScreenState();
}

class _ExamCoursesFilterScreenState
    extends ConsumerState<ExamCoursesFiltersScreen>
    with TickerProviderStateMixin {
  List<String> tabsList = [], yearsDropDown = ["2012", "2013"];
  String currentTab = "";
  String yearDropDownValue = "";
  bool initializingPage = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

    final pageController = ref.read(pageNavigationProvider.notifier);
    final apiState = ref.watch(examCoursesFilterApiProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageController.navigatePage(3);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text("Filter Exams"),
        centerTitle: true,
        //elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 26),
          child: Container(
            width: size.width,
            color: Colors.white,
            height: 24,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ),
        ),
      ),
      body: apiState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.mainBlue,
            strokeWidth: 5,
          ),
        ),
        error: (error, _) => AsyncErrorWidget(
          errorMsg: error.toString().replaceAll("Exception:", ""),
          callback: () async {
            await ref
                .read(examCoursesFilterApiProvider.notifier)
                .fetchExamCourses();
          },
        ),
        data: (examCourses) {
          return DefaultTabController(
            length: examCourses.length,
            child: Column(
              children: [
                CustomTabBar(
                  isScrollable: true,
                  alignment: TabAlignment.start,
                  tabs: examCourses
                      .map(
                        (course) => Tab(height: 28, text: course.title),
                      )
                      .toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: examCourses
                        .map(
                          (course) => YearsList(
                            course: course,
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
