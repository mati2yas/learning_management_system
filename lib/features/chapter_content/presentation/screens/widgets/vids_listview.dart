import 'package:flutter/material.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/courses/presentation/widgets/course_video_tile.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class VideosListView extends StatelessWidget {
  final List<Video> videos;
  const VideosListView({
    super.key,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: videos.length,
      itemBuilder: (context, index) => VideoTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(Routes.chapterVideo, arguments: videos[index]);
        },
        video: videos[index],
      ),
      separatorBuilder: (_, index) => const SizedBox(height: 10),
    );
  }
}
