import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_year_provider.dart';
import 'package:lms_system/features/exam_grade_filter/provider/exam_grade_filter_provider.dart';
import 'package:lms_system/features/exam_questions/provider/current_id_stub_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/provider/current_exam_course_id.dart';
import 'package:lms_system/features/exams/provider/timer_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class PaidScreen extends ConsumerWidget {
  final int tabIndex;
  const PaidScreen({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesApiState = ref.watch(paidCoursesApiProvider);
    final examsApiState = ref.watch(paidExamsApiProvider);
    final coursesApiController = ref.watch(paidCoursesApiProvider.notifier);
    final examsApiController = ref.watch(paidExamsApiProvider.notifier);

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      initialIndex: tabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Courses and Exams"),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
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
                  Future.wait([
                    ref
                        .refresh(paidCoursesApiProvider.notifier)
                        .fetchPaidCourses(),
                    ref.refresh(paidExamsApiProvider.notifier).fetchPaidExams(),
                  ]);
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
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 210,
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              UtilFunctions.getResponsiveChildAspectRatio(size),
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
                              pageNavController.navigatePage(
                                5,
                                arguments: {
                                  "course": courses[index],
                                  "previousScreenIndex": 2,
                                },
                              );
                            },
                            child: CourseCardNetworkImage(
                              mainAxisExtent: 210,
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
              error: (error, stack) => Center(
                child: Text(
                  ApiExceptions.getExceptionMessage(error as Exception, 400),
                  style: textTh.titleMedium!.copyWith(color: Colors.red),
                ),
              ),
              data: (exams) => exams.isEmpty
                  ? NoDataWidget(
                      noDataMsg: "No Paid Exams Yet.",
                      callback: () async {
                        await ref
                            .refresh(paidExamsApiProvider.notifier)
                            .fetchPaidExams();
                      },
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
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
                                      trailing: exams[index].examType ==
                                              UtilFunctions()
                                                  .getExamStringValue(
                                                      ExamType.matric)
                                          ? PopupMenuButton<void>(
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
                                                      "exam course": exams[
                                                              index]
                                                          .parentCourseTitle,
                                                      "exam year":
                                                          exams[index].examYear,
                                                      "previousScreen": 2,
                                                      "hasTimerOption": true,
                                                      "duration":
                                                          exams[index].duration,
                                                    };
                                                    ref
                                                        .read(
                                                            currentIdStubProvider
                                                                .notifier)
                                                        .changeStub({
                                                      "idType": IdType.all,
                                                      "id": exams[index].examId,
                                                      "courseId": exams[index]
                                                          .parentCourseId,
                                                    });
                                                    ref
                                                        .refresh(
                                                            examQuestionsApiProvider
                                                                .notifier)
                                                        .fetchQuestions();
                                                    ref
                                                        .read(examTimerProvider
                                                            .notifier)
                                                        .resetTimer(
                                                            duration:
                                                                exams[index]
                                                                    .duration);
                                                    pageNavController
                                                        .navigatePage(6,
                                                            arguments:
                                                                examData);
                                                  },
                                                  child: const ListTile(
                                                    leading: Icon(
                                                        Icons.question_answer),
                                                    title: Text('Take All'),
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
                                                        .navigatePage(
                                                      8,
                                                      arguments: <String,
                                                          dynamic>{
                                                        "exam course": exams[
                                                                index]
                                                            .parentCourseTitle,
                                                        "exam year":
                                                            exams[index]
                                                                .examYear,
                                                        "previous screen": 2,
                                                        //"courseId": course.id,
                                                      },
                                                    );
                                                  },
                                                  child: const ListTile(
                                                    leading:
                                                        Icon(Icons.filter_alt),
                                                    title: Text('Filter'),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : FilledButton(
                                              style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.mainBlue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (exams[index].examType ==
                                                    UtilFunctions()
                                                        .getExamStringValue(
                                                            ExamType.matric)) {
                                                } else {
                                                  // if null then other pages, move on to
                                                  // questions page
                                                  Map<String, dynamic>
                                                      examData = {
                                                    "exam course": exams[index]
                                                        .parentCourseTitle,
                                                    "exam year":
                                                        exams[index].examYear,
                                                    "previousScreen": 2,
                                                    "hasTimerOption": false,
                                                  };
                                                  pageNavController
                                                      .navigatePage(6,
                                                          arguments: examData);
                                                }
                                              },
                                              child: const Text("Take"),
                                            ),
                                    ),
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
}
