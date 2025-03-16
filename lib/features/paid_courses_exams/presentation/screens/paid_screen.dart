import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_courses_provider.dart';
import 'package:lms_system/features/paid_courses_exams/provider/paid_exam_provider.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class PaidScreen extends ConsumerWidget {
  const PaidScreen({super.key});

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
                    coursesApiController.fetchPaidCourses(),
                    examsApiController.fetchPaidExams(),
                  ]);
                },
              ),
              data: (courses) => SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 175,
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
                        courseIdController.changeCourseId(courses[index].id);

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
                        onBookmark: () {
                          coursesApiController.toggleSaved(courses[index]);
                        },
                        onLike: () {
                          coursesApiController.toggleLiked(courses[index]);
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
              data: (exams) => SizedBox(
                width: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, index) => const SizedBox(height: 15),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(exams[index].examYear),
                          subtitle: Text(exams[index].examType),
                        ),
                      ),
                    );
                  },
                  itemCount: exams.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
