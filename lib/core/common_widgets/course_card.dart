import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/shared_course/model/shared_course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  Function? onBookmark;

  CourseCard({
    super.key,
    required this.course,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1,
          color: AppColors.mainGrey,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  "assets/images/${course.image}",
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -13,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    print("press?");
                    if (onBookmark != null) {
                      onBookmark!();
                    }
                  },
                  icon: Icon(
                    course.saved ? Icons.bookmark : Icons.bookmark_outline,
                    color: AppColors.mainBlue,
                    size: 35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              course.title,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/topics.svg",
                  width: 12,
                  height: 12,
                  colorFilter: const ColorFilter.mode(
                    AppColors.mainBlue,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                Text("${course.topics} Topics"),
                const Spacer(),
                if (!course.subscribed)
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                    onPressed: () {
                      print("course subbed? ${course.subscribed}");
                    },
                    child: const Row(
                      children: [
                        Text("Buy"),
                        Icon(
                          Icons.lock,
                        ),
                      ],
                    ),
                  )
                // SizedBox(
                //   child: Column(
                //     children: [
                //       Text(
                //         "${course.saves} Saves",
                //         style: textTh.labelSmall,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
