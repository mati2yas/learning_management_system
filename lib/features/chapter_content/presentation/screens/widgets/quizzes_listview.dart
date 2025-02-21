import 'package:flutter/material.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/quiz/model/quiz_model.dart';

class QuizzesListView extends StatelessWidget {
  final List<Quiz> quizzes;
  const QuizzesListView({
    super.key,
    required this.quizzes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: quizzes.length,
      itemBuilder: (_, index) => ChapterQuizTile(quiz: quizzes[index]),
      separatorBuilder: (_, index) => const SizedBox(height: 10),
    );
  }
}
