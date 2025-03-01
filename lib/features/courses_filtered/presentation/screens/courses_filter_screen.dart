import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/presentation/widgets/search_delegate.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';

import '../../../wrapper/provider/wrapper_provider.dart';

class CoursesFilterScreen extends ConsumerStatefulWidget {
  const CoursesFilterScreen({
    super.key,
  });

  @override
  ConsumerState<CoursesFilterScreen> createState() =>
      _CoursesFilterScreenState();
}

enum HsClasses { lowerHs, prepHs }

class _CoursesFilterScreenState extends ConsumerState<CoursesFilterScreen> {
  Map<String, List<Course>> highschoolTabCourses = {
    AppStrings.grade9: [],
    AppStrings.grade10: [],
    AppStrings.grade11: [],
    AppStrings.grade12: [],
  };

  List<String> dropdownItems = [];
  HsClasses hsClasses = HsClasses.lowerHs;
  String? dropDownValue = "Natural";
  String selectedDepartment = "All";

  int? currentTabIndex;
  List<Course> selectedCourses = [];
  Set<String> uniqueDepartments = {};
  @override
  Widget build(BuildContext context) {
    var category = ref.watch(currentCourseFilterProvider);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageNavController = ref.read(pageNavigationProvider.notifier);

    final courseIdController = ref.watch(currentCourseIdProvider.notifier);
    final apiState = ref.watch(coursesFilteredProvider);

    return DefaultTabController(
      length: filterGrades(category).length,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              currentTabIndex = tabController.index;
              updateDropdownValue();
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                pageNavController.navigatePage(1);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              AppStrings.categoryFormatted[category]!,
              style: textTh.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: CourseSearchDelegate(
                        widgetRef: ref, previousScreenIndex: 1),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
            centerTitle: true,
            elevation: 5,
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.black87,
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(size.width, 76),
              child: Container(
                width: size.width,
                color: Colors.white,
                height: 76,
                child: Column(
                  spacing: 5,
                  children: [
                    //CustomSearchBar(hintText: "Search Courses", size: size),
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
                          if (category == AppStrings.universityCategory)
                            ElevatedButton(
                              onPressed: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    width: size.width,
                                    height: size.height * 0.6,
                                    child: DraggableScrollableSheet(
                                      maxChildSize: 1,
                                      initialChildSize: 1,
                                      minChildSize: 0.4,
                                      builder: (context, controller) => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Select Department",
                                              style: textTh.bodyLarge,
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: AppStrings
                                                  .universityDepartments.length,
                                              itemBuilder: (_, index) =>
                                                  ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    selectedDepartment = AppStrings
                                                            .universityDepartments[
                                                        index];
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                title: Text(
                                                  AppStrings
                                                          .universityDepartments[
                                                      index],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Select Department"),
                            ),
                        ],
                      ),
                    ),
                    if (category != AppStrings.otherCoursesCategory)
                      CustomTabBar(
                        alignment: TabAlignment.start,
                        isScrollable: true,
                        tabs: filterGrades(category)
                            .map(
                              (grd) => Tab(
                                height: 24,
                                text: grd,
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
                error: (error, stack) => AsyncErrorWidget(
                  errorMsg: error.toString().replaceAll("Exception:", ""),
                  callback: () async {
                    await ref
                        .read(coursesFilteredProvider.notifier)
                        .fetchCoursesFiltered(filter: category);
                  },
                ),
                data: (courses) {
                  //debugPrint("current category: $category");
                  //debugPrint("courses len: ${courses.length}");
                  return category == AppStrings.otherCoursesCategory
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                            mainAxisExtent: 200,
                          ),
                          itemCount: courses.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                courseIdController
                                    .changeCourseId(courses[index].id);

                                ref
                                    .read(courseChaptersProvider.notifier)
                                    .fetchCourseChapters();

                                ref
                                    .read(courseSubTrackProvider.notifier)
                                    .changeCurrentCourse(courses[index]);

                                debugPrint(
                                    "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
                                pageNavController.navigatePage(
                                  5,
                                  arguments: {
                                    "previousScreenIndex": 4,
                                    "course": courses[index],
                                  },
                                );
                              },
                              child: CourseCard(course: courses[index]),
                            );
                          },
                        )
                      : TabBarView(
                          controller: tabController,
                          children: filterGrades(category).map((grade) {
                            //
                            switch (category) {
                              case AppStrings.universityCategory:
                                // for (var c in courses) {
                                //   debugPrint(
                                //       "course id: ${c.id}, course batch : ${c.batch}, course dep: ${c.department?.substring(0, 8)}, current department: ${selectedDepartment.substring(0, 8)}");
                                // }
                                if (selectedDepartment == "All") {
                                  selectedCourses = courses;
                                } else {
                                  selectedCourses =
                                      selectedCourses.where((course) {
                                    debugPrint(
                                        "course dep: ${course.department}");
                                    return course.department ==
                                        selectedDepartment;
                                  }).toList();
                                }
                                selectedCourses = selectedCourses
                                    .where((course) =>
                                        course.batch ==
                                        AppStrings.universityGrades[
                                            currentTabIndex ?? 0])
                                    .toList();
                                break;
                              case AppStrings.highSchoolCategory:
                                if (grade == AppStrings.grade9 ||
                                    grade == AppStrings.grade10) {
                                  selectedCourses = courses
                                      .where((course) =>
                                          course.grade ==
                                          AppStrings.highSchoolGrades[
                                              currentTabIndex ?? 0])
                                      .toList();
                                } else if (grade == AppStrings.grade11 ||
                                    grade == AppStrings.grade12) {
                                  selectedCourses = courses
                                      .where((course) =>
                                          course.grade ==
                                              AppStrings.highSchoolGrades[
                                                  currentTabIndex ?? 0] &&
                                          course.stream?.toLowerCase() ==
                                              dropDownValue?.toLowerCase())
                                      .toList();
                                }
                                String theList = selectedCourses
                                    .take(
                                        (selectedCourses.length * 0.75).toInt())
                                    .map((course) =>
                                        "{${course.grade},${course.stream}}")
                                    .join("|");
                                debugPrint("current Courses: $theList");
                                break;
                              case AppStrings.lowerGradesCategory:
                                selectedCourses = courses
                                    .where((course) =>
                                        course.grade ==
                                        AppStrings
                                            .lowerGrades[currentTabIndex ?? 0])
                                    .toList();
                                break;
                              default:
                                selectedCourses = courses;
                                break;
                            }
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.8,
                                mainAxisExtent: 200,
                              ),
                              itemCount: selectedCourses.length,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    courseIdController.changeCourseId(
                                        selectedCourses[index].id);

                                    ref
                                        .read(courseChaptersProvider.notifier)
                                        .fetchCourseChapters();

                                    ref
                                        .read(courseSubTrackProvider.notifier)
                                        .changeCurrentCourse(courses[index]);

                                    debugPrint(
                                        "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
                                    pageNavController.navigatePage(
                                      5,
                                      arguments: {
                                        "previousScreenIndex": 4,
                                        "course": selectedCourses[index],
                                      },
                                    );
                                  },
                                  child: CourseCard(
                                      course: selectedCourses[index]),
                                );
                              },
                            );
                          }).toList(),
                        );
                },
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
      return AppStrings.lowerGrades;
    }
    if (category == "high_school") {
      return AppStrings.highSchoolGrades;
    }
    if (category == "university") {
      return AppStrings.universityGrades;
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
    //List<String> dropdownItems = [];
    if (category == "high_school" &&
        (currentTabIndex == 0 || currentTabIndex == 1)) {
      dropdownItems = [];
      dropDownValue = null;
    } else if (category == "high_school" && [2, 3].contains(currentTabIndex)) {
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
