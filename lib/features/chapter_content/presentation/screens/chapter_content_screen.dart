import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/chapter_content/presentation/screens/widgets/quizzes_listview.dart';
import 'package:lms_system/features/chapter_content/presentation/screens/widgets/vids_listview.dart';
import 'package:lms_system/features/chapter_content/provider/chapter_content_provider.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_document_tile.dart';
import 'package:lms_system/features/document_viewer/model/document_status.dart';
import 'package:lms_system/features/document_viewer/presentation/screens/document_viewer_screen.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/presentation/widgets/custom_tab_bar.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';

import '../../../document_viewer/provider/document_viewer_provider.dart';

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

class _ChapterContentScreenState extends ConsumerState<ChapterContentScreen>
    with SingleTickerProviderStateMixin {
  DocumentStatus documentStatus = DocumentStatus.idle;
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    final apiState = ref.watch(chapterContentProvider);
    Chapter chapter = widget.chapter;
    var documentState = ref.watch(documentProvider);
    final currentCourse = ref.watch(courseSubTrackProvider);
    debugPrint(
        "current course: Course{ id: ${currentCourse.id}, title: ${currentCourse.title} }");
    return OrientationBuilder(
      builder: (context, orientation) {
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
                      height: 30,
                      text: "Video",
                    ),
                    Tab(
                      height: 30,
                      text: "Document",
                    ),
                    Tab(
                      height: 30,
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
              error: (error, stack) => AsyncErrorWidget(
                errorMsg: error.toString(),
                callback: () async {
                  ref
                      .refresh(chapterContentProvider.notifier)
                      .fetchChapterContent();
                },
              ),
              data: (chapterContent) {
                return Stack(
                  children: [
                    TabBarView(
                      children: [
                        chapterContent.videos.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Documents For This Chapter Yet.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : VideosListView(
                                chapterOrder: chapterContent.order,
                                videos: chapterContent.videos,
                              ),
                        chapterContent.documents.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Documents For This Chapter Yet.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: chapterContent.documents.length,
                                itemBuilder: (context, index) =>
                                    ChapterDocumentTile(
                                  document: chapterContent.documents[index],
                                  callBack: () async {
                                    if (currentCourse.subscribed) {
                                      debugPrint("course subbed");
                                      var docProcessor =
                                          ref.read(documentProvider.notifier);

                                      String identifier =
                                          chapterContent.documents[index].title;
                                      await docProcessor.processPDF(
                                          chapterContent
                                              .documents[index].fileUrl,
                                          identifier);

                                      if (context.mounted) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SecurePDFViewer(),
                                          ),
                                        );
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Cannot access contents'),
                                          content: const Text(
                                            "You need to buy this course to access contents",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                        chapterContent.quizzes.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Quizzes For This Chapter Yet.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : QuizzesListView(
                                chapterOrder: chapterContent.order,
                                quizzes: chapterContent.quizzes,
                              ),
                      ],
                    ),
                    if ([
                      DocumentStatus.downloading,
                      DocumentStatus.encrypting,
                      DocumentStatus.decrypting
                    ].contains(documentState.status)) ...[
                      Container(
                        height: size.height,
                        width: size.width,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            spacing: 10,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.mainBlue,
                              ),
                              Text(
                                "${capitalize(documentState.status.name)} Document...",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.mainBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  String capitalize(String input) {
    String first = input[0];
    input = input.replaceFirst(first, first.toUpperCase());
    return input;
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
