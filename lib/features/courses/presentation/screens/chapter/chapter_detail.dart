import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_document_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/course_video_tile.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';

import '../../../provider/chapter_videos_index.dart';

class ChapterDetailPage extends ConsumerStatefulWidget {
  final Chapter chapter;
  const ChapterDetailPage({
    super.key,
    required this.chapter,
  });

  @override
  ConsumerState<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends ConsumerState<ChapterDetailPage>
    with SingleTickerProviderStateMixin {
  int seconds = 0;
  late TabController controller;

  @override
  Widget build(BuildContext context) {
    var videoIndex = ref.watch(currentPlayingVideoTracker);
    var videosIndexCtrl = ref.watch(currentPlayingVideoTracker.notifier);
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    Chapter chapter = widget.chapter;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${chapter.name} -- ${chapter.title}",
            style: textTh.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          elevation: 5,
          shadowColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, kTextTabBarHeight - 10),
            child: CustomTabBar(
              isScrollable: false,
              alignment: TabAlignment.fill,
              controller: controller,
              tabs: const [
                Tab(
                  text: "Video",
                ),
                Tab(text: "Document"),
                Tab(text: "Quizzes"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: chapter.videos.length,
              itemBuilder: (context, index) => VideoTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.chapterVideo,
                      arguments: chapter.videos[index]);
                },
                video: chapter.videos[index],
              ),
              separatorBuilder: (_, index) => const SizedBox(height: 10),
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: const [
                ChapterDocumentTile(),
                ChapterDocumentTile(),
                ChapterDocumentTile(),
                ChapterDocumentTile(),
                ChapterDocumentTile(),
                ChapterDocumentTile(),
              ],
            ),
            ListView(
              children: const [
                ChapterQuizTile(),
                SizedBox(height: 15),
                ChapterQuizTile(),
                SizedBox(height: 15),
                ChapterQuizTile(),
                SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }
}
