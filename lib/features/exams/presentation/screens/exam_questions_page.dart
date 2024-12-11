import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

class ExamQuestionsPage extends ConsumerStatefulWidget {
  const ExamQuestionsPage({super.key});

  @override
  ConsumerState<ExamQuestionsPage> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends ConsumerState<ExamQuestionsPage> {
  PageController pageViewController = PageController();
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    final pageNavController = ref.read(pageNavigationProvider.notifier);
    final examData =
        pageNavController.getArgumentsForPage(6) as Map<String, dynamic>;
    final examTitle = examData["exam title"]!;
    final examYear = examData["exam year"]!;
    final questions = examData["questions"]! as List<Question>;
    bool answerRevealed = false;
    final Map<int, String> selectedAnswers = {}; // Store selected answers
    print("questions length: ${questions.length}");

    List<String> answers = [];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageNavController.navigatePage(3);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "$examYear $examTitle",
          style: textTh.titleLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black87,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    examTitle,
                    style: textTh.titleMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 18,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageViewController,
              itemBuilder: (_, index) {
                var currentQuestion = questions[index];
                bool answerRevealed = false;
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          currentQuestion.question,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...currentQuestion.options.map((op) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: size.width * 0.55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Radio<String>(
                                  activeColor: AppColors.mainBlue,
                                  value: op,
                                  groupValue: selectedAnswers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAnswers[index] = value!;
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  op,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            answerRevealed = !answerRevealed;
                          });
                        },
                        label: const Text("Reveal Solution"),
                      ),
                      const SizedBox(height: 15),
                      if (answerRevealed) ...[
                        Text(currentQuestion.answer),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 2,
                              color: AppColors.darkerGrey,
                            ),
                          ),
                          child: Text(currentQuestion.answer),
                        )
                      ],
                      SizedBox(
                        width: size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 4,
                              ),
                              onPressed: () {
                                pageViewController.previousPage(
                                  duration: const Duration(milliseconds: 850),
                                  curve: Curves.decelerate,
                                );
                              },
                              child: const Text(
                                "Previous",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainBlue,
                                elevation: 4,
                              ),
                              onPressed: () {
                                pageViewController.nextPage(
                                  duration: const Duration(milliseconds: 850),
                                  curve: Curves.decelerate,
                                );
                              },
                              child: const Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemCount: questions.length,
            ),
          ),
        ],
      ),
    );
  }
}
