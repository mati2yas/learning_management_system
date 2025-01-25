import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_search_bar.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';

import '../../../wrapper/provider/wrapper_provider.dart';

List<String> highSchoolGrades = ["Grade 9", "Grade 10", "Grade 11", "Grade 12"];
List<String> lowerGrades = [
  "Grade 1",
  "Grade 2",
  "Grade 3",
  "Grade 4",
  "Grade 5",
  "Grade 6",
  "Grade 7",
  "Grade 8"
];
List<String> universityGrades = [
  "Freshman",
  "1st year",
  "2nd year",
  "3rd year",
  "4th year",
  "5th year"
];

class CoursesFilterScreen extends ConsumerStatefulWidget {
  const CoursesFilterScreen({
    super.key,
  });

  @override
  ConsumerState<CoursesFilterScreen> createState() =>
      _CoursesFilterScreenState();
}

class _CoursesFilterScreenState extends ConsumerState<CoursesFilterScreen> {
  String? dropDownValue;
  int? currentTabIndex;
  List<Course> selectedCourses = [];
  @override
  Widget build(BuildContext context) {
    var category = ref.watch(currentCourseFilterProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageController = ref.read(pageNavigationProvider.notifier);
    //final coursesFilteredState = ref.watch(coursesfilpro)
    //final coursesFilteredState =
    // Determine dropdown items dynamically
    List<String> dropdownItems = [];

    final courseIdController = ref.watch(currentCourseIdProvider.notifier);
    final apiState = ref.watch(coursesFilteredProvider);

    if (category == "high_school" && [2, 3].contains(currentTabIndex)) {
      dropdownItems = ["Natural", "Social"];
    } else if (category == "university") {
      dropdownItems = [];
    }

    return DefaultTabController(
      length: filterGrades(category).length,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              currentTabIndex = tabController.index;
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                pageController.navigatePage(1);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              category,
              style: textTh.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.black87,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(size.width, 121),
              child: Container(
                width: size.width,
                color: Colors.white,
                height: 121,
                child: Column(
                  spacing: 5,
                  children: [
                    CustomSearchBar(hintText: "Search Courses", size: size),
                    SizedBox(
                      width: size.width * 0.85,
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Categories",
                            style: textTh.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (dropdownItems.isNotEmpty)
                            DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: dropDownValue,
                              items: dropdownItems
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownValue = value!;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    CustomTabBar(
                      alignment: TabAlignment.start,
                      isScrollable: true,
                      tabs: filterGrades(category)
                          .map(
                            (grd) => Tab(
                              height: 24,
                              child: Text(
                                grd,
                                style: textTh.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                          .toList(),
                      //controller: tabController,
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: apiState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainBlue,
                    strokeWidth: 5,
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    error.toString(),
                    style: textTh.titleMedium!.copyWith(color: Colors.red),
                  ),
                ),
                data: (courses) => TabBarView(
                  controller: tabController,
                  children: filterGrades(category).map((grade) {
                    if (category == "university") {
                      selectedCourses = courses
                          .where((course) =>
                              course.batch ==
                              universityGrades[currentTabIndex ?? 0])
                          .toList();
                    } else if (category == "high_school") {
                      selectedCourses = courses
                          .where((course) =>
                              course.batch ==
                              highSchoolGrades[currentTabIndex ?? 0])
                          .toList();
                      if (["Grade 11", "Grade 12"].contains(grade)) {
                        selectedCourses = selectedCourses
                            .where((course) =>
                                course.streamOrDepartment == dropDownValue)
                            .toList();
                      }
                    } else if (category == "lower_grades") {
                      selectedCourses = courses
                          .where((course) =>
                              course.grade == lowerGrades[currentTabIndex ?? 0])
                          .toList();
                    } else {
                      selectedCourses = courses;
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: selectedCourses.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            courseIdController
                                .changeCourseId(selectedCourses[index].id);
                            pageController.navigatePage(
                              5,
                              arguments: selectedCourses[index],
                            );
                          },
                          child: CourseCard(course: selectedCourses[index]),
                        );
                      },
                    );
                  }).toList(),
                ),
              )),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<String> filterGrades(String category) {
    if (category == "lower_grades") {
      return lowerGrades;
    }
    if (category == "high_school") {
      return highSchoolGrades;
    }
    if (category == "university") {
      return universityGrades;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();

    updateDropdownValue();
  }

  /// Updates the dropDownValue based on the current tab index and category type
  void updateDropdownValue() {
    final category = ref.read(currentCourseFilterProvider);
    List<String> grades = filterGrades(category);
    // Determine dropdown items
    List<String> dropdownItems = [];

    if (category == "high_school" && [2, 3].contains(currentTabIndex)) {
      dropdownItems = ["Natural", "Social"];
    } else if (category == "university") {
      // var items =  (grades)
      //     .where((grade) => grade.subCategories?.isNotEmpty ?? false)
      //     .expand((grade) => grade.subCategories!.map((sub) => sub.name))
      //     .toList();

      // deal with the above another time
    }

    // Update dropDownValue
    if (dropDownValue == null || !dropdownItems.contains(dropDownValue)) {
      dropDownValue = dropdownItems.isNotEmpty ? dropdownItems.first : null;
    }
  }
}
