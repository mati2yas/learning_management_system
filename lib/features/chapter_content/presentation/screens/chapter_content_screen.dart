import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/chapter_content/provider/chapter_content_provider.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_document_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/courses/presentation/widgets/course_video_tile.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';

class ChapterContentScreen extends ConsumerStatefulWidget {
  final Chapter chapter;
  const ChapterContentScreen({
    super.key,
    required this.chapter,
  });

  @override
  ConsumerState<ChapterContentScreen> createState() =>
      _ChapterContentScreenState();
}

class DocumentsListView extends StatelessWidget {
  final List<Document> documents;
  const DocumentsListView({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: documents.length,
      itemBuilder: (context, index) => ChapterDocumentTile(
        document: documents[index],
      ),
    );
  }
}

class QuizzesListView extends StatelessWidget {
  const QuizzesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ChapterQuizTile(),
        SizedBox(height: 15),
        ChapterQuizTile(),
        SizedBox(height: 15),
        ChapterQuizTile(),
        SizedBox(height: 15),
      ],
    );
  }
}

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

class _ChapterContentScreenState extends ConsumerState<ChapterContentScreen>
    with SingleTickerProviderStateMixin {
  //late TabController controller;

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    final apiState = ref.watch(chapterContentProvider);
    Chapter chapter = widget.chapter;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            chapter.name,
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
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 45),
            child: CustomTabBar(
              isScrollable: false,
              alignment: TabAlignment.fill,
              tabs: [
                Tab(
                  height: 24,
                  text: "Video",
                ),
                Tab(
                  height: 24,
                  text: "Document",
                ),
                Tab(
                  height: 24,
                  text: "Quizzes",
                ),
              ],
            ),
          ),
        ),
        body: apiState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.mainBlue,
              strokeWidth: 5,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              error.toString(),
              style: textTh.titleMedium!.copyWith(color: Colors.red),
            ),
          ),
          data: (chapterContent) {
            return TabBarView(
              //controller: controller,
              children: [
                VideosListView(videos: chapterContent.videos),
                DocumentsListView(documents: chapterContent.documents),
                const QuizzesListView(),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
