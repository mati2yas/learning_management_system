import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/model/categories_sub_categories.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ListTilewidget extends ConsumerWidget {
  final Course course;

  final TextTheme textTh;
  const ListTilewidget({
    super.key,
    required this.course,
    required this.textTh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.read(pageNavigationProvider.notifier);
    return Card(
      elevation: 3,
      color: Colors.white,
      shadowColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        leading: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              "assets/images/${course.image}",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(course.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 30,
            //   width: 220,
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: 100,
            //         child: LinearProgressIndicator(
            //           value: course.progress / 100,
            //           color: AppColors.mainBlue,
            //           backgroundColor: AppColors.mainGrey,
            //         ),
            //       ),
            //       const SizedBox(width: 5),
            //       Text(
            //         "${course.progress.toInt()} %",
            //         style: textTh.labelMedium,
            //       ),
            //     ],
            //   ),
            // ),
            Text("${course.topics} topics"),
          ],
        ),
        trailing: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: AppColors.mainBlue,
            maximumSize: const Size(40, 40),
            minimumSize: const Size(20, 20),
          ),
          onPressed: () {
            pageController.navigatePage(5,
                arguments: CourseCategory(
                    id: "0",
                    name: course.title,
                    grades: [
                      Grade(
                        id: "",
                        name: "name",
                        courses: [course],
                      ),
                    ],
                    categoryType: CategoryType.highSchool));
          },
          icon: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
