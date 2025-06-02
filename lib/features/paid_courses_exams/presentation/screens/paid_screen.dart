import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_screen_tab_index_prov.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class PaidScreen extends ConsumerStatefulWidget {
  const PaidScreen({
    super.key,
  });

  @override
  ConsumerState<PaidScreen> createState() => _PaidScreenState();
}

class _PaidScreenState extends ConsumerState<PaidScreen> {
  @override
  Widget build(BuildContext context) {
    final coursesApiState = ref.watch(paidCoursesApiProvider);
    final coursesApiController = ref.watch(paidCoursesApiProvider.notifier);
    final examsApiController = ref.watch(paidExamsApiProvider.notifier);
    final examsApiState = ref.watch(paidExamsApiProvider);
    int tabIndex = ref.watch(paidScreenTabIndexProv);
    int currentTabIndex = tabIndex;

    bool isWideScreen = MediaQuery.sizeOf(context).width > 600;
    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Builder(builder: (context) {
        final tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            setState(() {
              currentTabIndex = tabController.index;
            });
            ref
                .read(paidScreenTabIndexProv.notifier)
                .changeTabIndex(tabController.index);
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Your Courses and Exams",
              style: textTh.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.black87,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () {
                  if (currentTabIndex == 0) {
                    ref
                        .refresh(paidCoursesApiProvider.notifier)
                        .fetchPaidCourses();
                  } else if (currentTabIndex == 1) {
                    ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams();
                  }
                },
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.mainBlue,
                ),
              )
            ],
            bottom: const PreferredSize(
              preferredSize: Size(double.infinity, 30),
              child: CustomTabBar(
                tabs: [
                  Tab(
                    height: 30,
                    text: "Courses",
                  ),
                  Tab(
                    height: 30,
                    text: "Exams",
                  )
                ],
                isScrollable: false,
              ),
            ),
          ),
          body: TabBarView(
            children: [
              coursesApiState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainBlue,
                    strokeWidth: 5,
                  ),
                ),
                error: (error, stack) => AsyncErrorWidget(
                  errorMsg: error.toString(),
                  callback: () async {
                    ref
                        .refresh(paidCoursesApiProvider.notifier)
                        .fetchPaidCourses();
                  },
                ),
                data: (courses) => SizedBox(
                  width: double.infinity,
                  child: courses.isEmpty
                      ? NoDataWidget(
                          noDataMsg: "No Paid Courses Yet.",
                          callback: () async {
                            await ref
                                .refresh(paidCoursesApiProvider.notifier)
                                .fetchPaidCourses();
                          },
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: 220,
                            crossAxisCount: isWideScreen ? 3 : 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio:
                                UtilFunctions.getResponsiveChildAspectRatio(
                                    size),
                          ),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                final courseIdController =
                                    ref.watch(currentCourseIdProvider.notifier);
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
                              pageNavController.navigateTo(
                                nextScreen: AppInts.courseChaptersPageIndex,
                                arguments: {
                                  "course": courses[index],
                                  "previousScreenIndex": 2,
                                },
                              );
                            },
                            child: CourseCardNetworkImage(
                              mainAxisExtent: 220,
                              onBookmark: () {
                                coursesApiController
                                    .toggleSaved(courses[index]);
                              },
                              onLike: () {
                                coursesApiController
                                    .toggleLiked(courses[index]);
                              },
                              course: courses[index],
                            ),
                          );
                        },
                        itemCount: courses.length,
                      ),
              ),
            ),
            examsApiState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  strokeWidth: 5,
                ),
              ),
              error: (error, stack) => AsyncErrorWidget(
                errorMsg: error.toString(),
                callback: () async {
                  await ref
                      .refresh(paidExamsApiProvider.notifier)
                      .fetchPaidExams();
                },
              ),
              data: (exams) => exams.isEmpty
                  ? NoDataWidget(
                      noDataMsg:
                          "You haven’t purchased any exams yet. Browse our selection and start practicing today!",
                      callback: () async {
                        await ref
                            .refresh(paidExamsApiProvider.notifier)
                            .fetchPaidExams();
                      },
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 15),
                        itemCount: exams.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: exams.isEmpty
                                  ? NoDataWidget(
                                      noDataMsg: "No Paid Exams Yet.",
                                      callback: () async {
                                        await ref
                                            .refresh(
                                                paidExamsApiProvider.notifier)
                                            .fetchPaidExams();
                                      },
                                    )
                                  : ListTile(
                                      title: Text(exams[index].examYear),
                                      subtitle:
                                          Text(exams[index].parentCourseTitle),
                                      trailing: (exams[index].examType ==
                                              UtilFunctions()
                                                  .getExamStringValue(
                                                      ExamType.matric))
                                          ? PopupMenuButton<void>(
                                              color: mainBackgroundColor,
                                              shape: Border.all(
                                                  color: primaryColor,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              // Vertical three dots,
                                              icon: const Icon(
                                                Icons.more_vert,
                                              ), // Vertical three dots
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry<void>>[
                                                PopupMenuItem<void>(
                                                  onTap: () {
                                                    // navigate to the page that
                                                    // shows the exam
                                                    Map<String, dynamic>
                                                        examData = {
                                                      AppStrings
                                                          .examCourseKey: exams[
                                                              index]
                                                          .parentCourseTitle,
                                                      AppStrings.examYearKey:
                                                          exams[index].examYear,
                                                      AppStrings
                                                          .previousScreenKey: 2,
                                                      AppStrings
                                                              .hasTimerOptionKey:
                                                          true,
                                                      AppStrings
                                                              .timerDurationKey:
                                                          exams[index].duration,
                                                    };
                                                    ref
                                                        .read(
                                                            currentIdStubProvider
                                                                .notifier)
                                                        .changeStub({
                                                      AppStrings.stubIdType:
                                                          IdType.all,
                                                      AppStrings.stubId:
                                                          exams[index].examId,
                                                      AppStrings.stubCourseId:
                                                          exams[index]
                                                              .parentCourseId,
                                                    });
                                                    ref
                                                        .refresh(
                                                            examQuestionsApiProvider
                                                                .notifier)
                                                        .fetchQuestions();

                                                    pageNavController
                                                        .navigateTo(
                                                      nextScreen: AppInts
                                                          .examQuestionsPageIndex,
                                                      arguments: examData,
                                                    );
                                                  },
                                                  child: const ListTile(
                                                    leading: Icon(
                                                      Icons.question_answer,
                                                      color: primaryColor,
                                                    ),
                                                    title: Text('Take all'),
                                                  ),
                                                ),
                                                PopupMenuItem<void>(
                                                  onTap: () {
                                                    // navigate to the page that
                                                    // further filter the exams
                                                    debugPrint(
                                                        "to page 8, exam title: examtitle");

                                                      ref
                                                          .read(
                                                              currentExamYearIdProvider
                                                                  .notifier)
                                                          .changeYearId(
                                                              exams[index]
                                                                  .examId);
                                                      ref
                                                          .read(
                                                              currentExamCourseIdProvider
                                                                  .notifier)
                                                          .changeCourseId(exams[
                                                                  index]
                                                              .parentCourseId);

                                                    ref
                                                        .read(
                                                            examGradeFilterApiProvider
                                                                .notifier)
                                                        .fetchExamGrades();
                                                    pageNavController
                                                        .navigateTo(
                                                      nextScreen: AppInts
                                                          .examGradeFilterPageIndex,
                                                      arguments: <String,
                                                          dynamic>{
                                                        AppStrings
                                                            .previousScreenKey: 2,
                                                        AppStrings
                                                            .examCourseKey: exams[
                                                                index]
                                                            .parentCourseTitle,
                                                        AppStrings.examYearKey:
                                                            exams[index]
                                                                .examYear,
                                                        AppStrings
                                                                .timerDurationKey:
                                                            exams[index]
                                                                .duration,
                                                        AppStrings
                                                                .hasTimerOptionKey:
                                                            true,
                                                      },
                                                    );
                                                  },
                                                  child: const ListTile(
                                                    leading: Icon(
                                                      Icons.filter_alt,
                                                      color: primaryColor,
                                                    ),
                                                    title:
                                                        Text('Take filtered'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : CustomButton(
                                              isFilledButton: true,
                                              buttonWidth: 50,
                                              buttonHeight: 35,
                                              buttonWidget: Text(
                                                'Take',
                                                style: textTheme.labelMedium!
                                                    .copyWith(
                                                        letterSpacing: 0.5,
                                                        fontFamily: "Inter",
                                                        color: Colors.white,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              ),
                                              buttonAction: () {
                                                if (exams[index].examType ==
                                                    UtilFunctions()
                                                        .getExamStringValue(
                                                            ExamType.matric)) {
                                                } else {
                                                  // if null then other pages, move on to
                                                  // questions page
                                                  Map<String, dynamic>
                                                      examData = {
                                                    AppStrings.examCourseKey:
                                                        exams[index]
                                                            .parentCourseTitle,
                                                    AppStrings.examYearKey:
                                                        exams[index].examYear,
                                                    AppStrings
                                                        .previousScreenKey: 2,
                                                    AppStrings
                                                            .hasTimerOptionKey:
                                                        false,
                                                    AppStrings.timerDurationKey:
                                                        exams[index].duration,
                                                  };
                                                  ref
                                                      .read(
                                                          currentIdStubProvider
                                                              .notifier)
                                                      .changeStub(
                                                    {
                                                      AppStrings.stubIdType:
                                                          IdType.all,
                                                      AppStrings.stubId:
                                                          exams[index].examId,
                                                      AppStrings.stubCourseId:
                                                          exams[index]
                                                              .parentCourseId,
                                                    },
                                                  );
                                                  ref
                                                      .refresh(
                                                          examQuestionsApiProvider
                                                              .notifier)
                                                      .fetchQuestions();
                                                  pageNavController.navigateTo(
                                                    nextScreen: AppInts
                                                        .examQuestionsPageIndex,
                                                    arguments: examData,
                                                  );
                                                }
                                              },
                                            )),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool checkFilterable(String examtype) {
    UtilFunctions uFunc = UtilFunctions();
    List<String> filterableTypes = [
      ExamType.matric,
      ExamType.exitexam,
      ExamType.ministry8th
    ].map((exType) => uFunc.getExamStringValue(exType)).toList();
    return filterableTypes.contains(examtype);
  }

  bool checkFilterable(String examtype) {
    UtilFunctions uFunc = UtilFunctions();
    List<String> filterableTypes = [
      ExamType.matric,
      ExamType.exitexam,
      ExamType.ministry8th
    ].map((exType) => uFunc.getExamStringValue(exType)).toList();
    return filterableTypes.contains(examtype);
  }
}
