import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/shared_course/model/shared_course_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  Function? onBookmark;
  Function? onLike;

  CourseCard({
    super.key,
    required this.course,
    this.onBookmark,
    this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      height: 180,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              course.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.mainBlue,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
                Text(
                  "${course.topics} Topics",
                  style: TextStyle(color: AppColors.darkerGrey),
                ),
              ],
            ),
          ),
          course.subscribed
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        if (onLike != null) {
                          onLike!();
                        }
                      },
                      icon: Icon(
                        course.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: AppColors.mainBlue,
                      ),
                      label: Text("${course.likes}"),
                    ),
                    Spacer(),
                    TextButton.icon(
                      // style: TextButton.styleFrom(
                      //     padding: const EdgeInsets.only(left: 8)),
                      onPressed: () {
                        if (onBookmark != null) {
                          onBookmark!();
                        }
                      },
                      icon: Icon(
                        course.saved ? Icons.bookmark : Icons.bookmark_outline,
                        color: AppColors.mainBlue,
                      ),
                      label: Text("${course.saves}"),
                    ),
                  ],
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.mainBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Buy",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.lock,
                        size: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
