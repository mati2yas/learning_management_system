import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/courses/presentation/widgets/course_video_tile.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';

class VideosListView extends ConsumerWidget {
  final List<Video> videos;
  const VideosListView({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCourse = ref.watch(courseSubTrackProvider);
    debugPrint(
        "current course: Course{ id: ${currentCourse.id}, title: ${currentCourse.title} }");
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: videos.length,
      itemBuilder: (context, index) => VideoTile(
        onTap: () {
          if (!currentCourse.subscribed) {
            if (index == 0) {
              debugPrint("course not subbed, index 0");
              Navigator.of(context)
                  .pushNamed(Routes.chapterVideo, arguments: videos[index]);
            } else {
              debugPrint("course not subbed, index not 0");
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cannot access contents'),
                  content: const Text(
                    "You need to buy this course to access more contents",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          } else {
            debugPrint("course subbed");
            Navigator.of(context)
                .pushNamed(Routes.chapterVideo, arguments: videos[index]);
          }
        },
        video: videos[index],
      ),
      separatorBuilder: (_, index) => const SizedBox(height: 10),
    );
  }
}
