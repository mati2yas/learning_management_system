import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/exams/provider/timer_provider.dart';
import 'package:lms_system/features/quiz/model/quiz_model.dart';
import 'package:lms_system/features/quiz/presentation/quiz_questions_screen.dart';
import 'package:lms_system/features/quiz/provider/current_quiz_id_provider.dart';
import 'package:lms_system/features/quiz/provider/quiz_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';

class QuizzesListView extends ConsumerWidget {
  final List<Quiz> quizzes;
  const QuizzesListView({
    super.key,
    required this.quizzes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCourse = ref.watch(courseSubTrackProvider);
    debugPrint(
        "current course: Course{ id: ${currentCourse.id}, title: ${currentCourse.title} }");
    return ListView.separated(
      itemCount: quizzes.length,
      itemBuilder: (_, index) => ChapterQuizTile(
        callback: () async {
          if (!currentCourse.subscribed) {
            if (index == 0) {
              debugPrint("course not subbed, index 0");
              ref
                  .read(currentQuizIdProvider.notifier)
                  .changeQuizId(quizzes[index].id.toString());
              Quiz quize =
                  await ref.refresh(quizProvider.notifier).fetchQuizData();
              ref.read(examTimerProvider.notifier).resetTimer(duration: 20);

              if (context.mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizQuestionsPage(quiz: quize),
                  ),
                );
              }
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
            ref
                .read(currentQuizIdProvider.notifier)
                .changeQuizId(quizzes[index].id.toString());
            Quiz quize =
                await ref.refresh(quizProvider.notifier).fetchQuizData();
            ref.read(examTimerProvider.notifier).resetTimer(duration: 30);

            if (context.mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizQuestionsPage(quiz: quize),
                ),
              );
            }
          }
        },
        quiz: quizzes[index],
      ),
      separatorBuilder: (_, index) => const SizedBox(height: 10),
    );
  }
}
