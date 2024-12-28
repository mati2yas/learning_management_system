import 'package:flutter/material.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_document_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_videos.dart';
import 'package:lms_system/features/shared_course/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChapterDetailPage extends StatefulWidget {
  final Chapter chapter;
  const ChapterDetailPage({
    super.key,
    required this.chapter,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late YoutubePlayerController ytCtrl;
  @override
  Widget build(BuildContext context) {
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
          bottom: const TabBar(
            tabs: [
              Tab(text: "Video"),
              Tab(text: "Document"),
              Tab(text: "Quizzes"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChapterVideosWidget(
              chapter: widget.chapter,
              ytCtrl: ytCtrl,
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
              padding: const EdgeInsets.all(12),
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
    ytCtrl = YoutubePlayerController(
      initialVideoId: widget.chapter.videos[0].title,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }
}
