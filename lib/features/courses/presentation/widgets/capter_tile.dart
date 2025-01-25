import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
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
        Navigator.of(context)
            .pushNamed(Routes.chapterContent, arguments: chapter);
      },
      child: Card(
        margin: const EdgeInsets.only(top: 3, left: 3, right: 2.6),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.5)),
        ),
        child: SizedBox(
          height: 55,
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.5),
                    bottomLeft: Radius.circular(5.5),
                  ),
                  child: SizedBox(
                    width: 55,
                    height: 55,
                    child: Image.asset(
                      "assets/images/applied_math.png",
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 15, 8.0),
                  child: Text(
                    "${chapter.name} | ${chapter.title}",
                    style: textTh.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
