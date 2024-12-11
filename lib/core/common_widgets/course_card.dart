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
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 160,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(
                "assets/images/${course.image}",
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  course.title,
                  style: const TextStyle(
                    color: AppColors.mainBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  course.desc,
                  style: const TextStyle(
                    color: AppColors.mainGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 4,
                          ),
                          foregroundColor: Colors.white,
                          fixedSize: const Size(75, 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                          ),
                        ),
                        onPressed: () {
                          print("course subbed? ${course.subscribed}");
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Buy",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.lock,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (course.subscribed)
              Flexible(
                child: SizedBox(
                  height: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 8)),
                          onPressed: () {
                            if (onBookmark != null) {
                              onBookmark!();
                            }
                          },
                          icon: Icon(
                            course.saved
                                ? Icons.bookmark
                                : Icons.bookmark_outlined,
                            color: AppColors.mainBlue,
                          ),
                          label: Text("${course.saves}")),
                      TextButton.icon(
                          onPressed: () {
                            if (onBookmark != null) {
                              onBookmark!();
                            }
                          },
                          icon: Icon(
                            course.liked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            color: AppColors.mainBlue,
                          ),
                          label: Text("${course.likes}")),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
