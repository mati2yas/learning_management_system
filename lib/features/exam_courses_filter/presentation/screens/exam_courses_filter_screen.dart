import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/exam_courses_filter/presentation/widgets/years_list.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/exam_courses_filter_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/subscription/provider/requests/exam_requests_provider.dart';
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

    var requestsProv = ref.watch(examRequestsProvider);

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    final appbarTitle = pageNavController.getArgumentsForPage(7);
    final apiState = ref.watch(examCoursesFilterApiProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageNavController.navigatePage(3);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.requests);
              },
              child: Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  if (requestsProv.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 18,
                        width: 18,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          "${requestsProv.length}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        title: Text(appbarTitle),
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
                            examType: ref.read(currentExamTypeProvider),
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
