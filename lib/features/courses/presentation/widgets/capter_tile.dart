import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/chapter_content/provider/chapter_content_provider.dart';
import 'package:lms_system/features/chapter_content/provider/current_chapter_id_provider.dart';

import '../../../shared/model/chapter.dart';

class ChapterTile extends ConsumerWidget {
  final Chapter chapter;

  const ChapterTile({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTh = Theme.of(context).textTheme;

    final currentChapterIdController =
        ref.watch(currentChapterIdProvider.notifier);
    return GestureDetector(
      onTap: () {
        currentChapterIdController.changeChapterId(chapter.id);
        ref.read(chapterContentProvider.notifier).fetchChapterContent();
        Navigator.of(context)
            .pushNamed(Routes.chapterContent, arguments: chapter);
      },
      child: Card(
        color: mainBackgroundColor,
        margin: const EdgeInsets.only(top: 1, left: 3, right: 2.6),
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: ListTile(
          title: Text(
            "Chapter ${chapter.order}",
            style: textTh.labelLarge!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            chapter.title,
            // overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: textTheme.titleMedium!.copyWith(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
