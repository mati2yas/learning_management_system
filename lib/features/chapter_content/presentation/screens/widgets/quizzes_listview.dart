import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_quiz_tile.dart';
import 'package:lms_system/features/quiz/model/quiz_model.dart';
import 'package:lms_system/features/quiz/provider/current_quiz_id_provider.dart';
import 'package:lms_system/features/quiz/provider/quiz_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';

class QuizzesListView extends ConsumerWidget {
  final List<Quiz> quizzes;
  final int chapterOrder;
  const QuizzesListView({
    super.key,
    required this.quizzes,
    required this.chapterOrder,
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
          if (currentCourse.subscribed) {
            debugPrint("course subbed");
            ref
                .read(currentQuizIdProvider.notifier)
                .changeQuizId(quizzes[index].id.toString());
            Quiz quize =
                await ref.refresh(quizProvider.notifier).fetchQuizData();
            // ref
            //     .read(examTimerProvider.notifier)
            //     .resetTimer(duration: quizzes[index].duration);

            if (context.mounted) {
              Navigator.of(context)
                  .pushNamed(Routes.quizQuestions, arguments: quize);
            }
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cannot access contents'),
                content: const Text(
                  "You need to buy this course to access contents",
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
        },
        quiz: quizzes[index],
      ),
      separatorBuilder: (_, index) => const SizedBox(height: 10),
    );
  }
}
