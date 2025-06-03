import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/status_bar_styles.dart';
import 'package:lms_system/features/exam_courses_filter/provider/current_exam_type_provider.dart';
import 'package:lms_system/features/exam_courses_filter/provider/exam_courses_filter_provider.dart';
import 'package:lms_system/features/exams/presentation/widgets/exam_category.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final pageNavController = ref.read(pageNavigationProvider.notifier);

    bool isWideScreen = MediaQuery.sizeOf(context).width > 600;
    double wideScreenHeight = 165 * 4 + 4 * 100;
    double narrowScreenHeight = 125 * 4 + 4 * 100;
    SystemChrome.setSystemUIOverlayStyle(darkAppBarSystemOverlayStyle);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Browse Exams",
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
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return SizedBox(
          //height: 125 * 4 + 16 * 4 + 100,
          height: isWideScreen ? wideScreenHeight : narrowScreenHeight,
          width: double.infinity,
          child: GridView(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 100,
              right: 15,
              left: 15,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: isWideScreen ? 165 : 125,
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 15,
            ),
            children: [
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.matric);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();
                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "ESSLCE",
                  );
                },
                categoryImage: "matric",
                categoryName: "ESSLCE",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.exitexam);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "Exit Exam",
                  );
                },
                categoryImage: "exit_exam",
                categoryName: "Exit Exam",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.uat);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "UAT",
                  );
                },
                categoryImage: "uat",
                categoryName: "UAT",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.ngat);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "NGAT",
                  );
                },
                categoryImage: "ngat",
                categoryName: "NGAT",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.ministry6th);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "6th Grade Ministry",
                  );
                },
                categoryImage: "ministry_6th",
                categoryName: "6th Grade Ministry",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.ministry8th);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "8th Grade Ministry",
                  );
                },
                categoryImage: "ministry_8th",
                categoryName: "8th Grade Ministry",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.sat);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "Standardized Tests",
                  );
                },
                categoryImage: "sat_exam",
                categoryName: "Standardized Tests",
              ),
              ExamCategoryShow(
                onTap: () {
                  ref
                      .read(currentExamTypeProvider.notifier)
                      .changeExamType(ExamType.exam);
                  ref
                      .read(examCoursesFilterApiProvider.notifier)
                      .fetchExamCourses();

                  pageNavController.navigateTo(
                    nextScreen: AppInts.examCoursesFiltersPageIndex,
                    //previousScreen: AppInts.examsPageIndex,
                    arguments: "Other Exams",
                  );
                },
                categoryImage: "other_exams",
                categoryName: "Other Exams",
              ),
            ],
          ),
        );
      }),
    );
  }
}
