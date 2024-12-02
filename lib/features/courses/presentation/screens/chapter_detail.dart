import 'package:flutter/material.dart';
import 'package:lms_system/features/shared_course/model/chapter.dart';

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
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    Chapter chapter = widget.chapter;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${chapter.name} -- ${chapter.title}",
          style: textTh.labelLarge,
        ),
      ),
    );
  }
}
