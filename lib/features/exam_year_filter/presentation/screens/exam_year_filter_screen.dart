import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exam_year_filter/presentation/widgets/years_list.dart';
import 'package:lms_system/features/exam_year_filter/provider/exam_year_filter_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamYearFiltersScreen extends ConsumerStatefulWidget {
  const ExamYearFiltersScreen({
    super.key,
  });

  @override
  ConsumerState<ExamYearFiltersScreen> createState() =>
      _ExamYearFilterScreenState();
}

class _ExamYearFilterScreenState extends ConsumerState<ExamYearFiltersScreen>
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
    final apiState = ref.watch(examYearFilterApiProvider);
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
            await ref.read(examYearFilterApiProvider.notifier).fetchExamYears();
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
    //initializingPage = true;

    // the logic is inside this cause ref cannot be called
    // in initstate since initState runs before the widgets
    // injected into the riverpod scope, and that causes
    // an error
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    //   // Extract unique years and tabs
    //   final Set uniqueYears = <String>{};
    //   final Set uniqueCourses = <String>{};
    //   for (var course in exam.courses) {
    //     uniqueCourses.add(course.title);
    //     for (var year in course.years) {
    //       uniqueYears.add(year.title);
    //     }
    //   }

    //   setState(() {
    //     var tabsSet = exam.courses.map((course) => course.title).toSet();
    //     print(tabsSet.join(","));
    //     tabsList = List.from(tabsSet);
    //     var yrDrops = <String>{};
    //     for (var course in exam.courses) {
    //       for (var year in course.years) {
    //         yrDrops.add(year.title);
    //       }
    //     }
    //     yearsDropDown = List.from(yrDrops);
    //     yearDropDownValue = yearsDropDown.first;
    //     // Initialize the TabController
    //     tabController = TabController(
    //       length: tabsList.length,
    //       vsync: this,
    //     );

    //     currentTab = tabsList[0];

    //     // Add listener to TabController
    //     tabController.addListener(() {
    //       setState(() {
    //         currentTab = tabsList[tabController.index];
    //         yearDropDownValue = "2012";
    //       });
    //     });
    //     initializingPage = false;
    //   }); // setState

    //   // addPostFrameCallback ends here
    // });
  }
}
