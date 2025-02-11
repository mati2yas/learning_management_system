import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exam_questions/provider/answers_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_layout.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../exams/provider/timer_provider.dart';

class ExamQuestionsPage extends ConsumerStatefulWidget {
  const ExamQuestionsPage({
    super.key,
  });

  @override
  ConsumerState<ExamQuestionsPage> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends ConsumerState<ExamQuestionsPage> {
  PageController pageViewController = PageController();
  PageNavigationController pageNavController = PageNavigationController();
  int middleExpandedFlex = 2;
  int currentQuestion = 0;
  int previousScreen =
      3; // we use wrapper screen index to track which screen we navigated from
  String examCourse = "", examYear = "", examChapter = "";
  Map<String, dynamic> examData = {};
  List<Question> questionsList = [];

  List<bool> questionContainsImage = [];
  bool initializingPage = false;
  int currentQuestionImageTrack = 0;
  ScreenLayoutConfig layoutConfig = ScreenLayoutConfig();
  bool allQuestionsAnswered = false;

  bool hasTimerOption = false;

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;

    final answersTrack = ref.watch(answersProvider);
    final answersController = ref.watch(answersProvider.notifier);
    var size = MediaQuery.of(context).size;
    final timerAsyncValue = ref.watch(examTimerProvider);

    final apiState = ref.watch(examQuestionsApiProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // reset timer and the go back to previous screen
            ref.read(examTimerProvider.notifier).resetTimer();
            pageNavController.navigatePage(previousScreen);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Column(
          children: [
            Text(
              "$examYear $examCourse",
              style: textTh.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (hasTimerOption)
              timerAsyncValue.when(
                data: (remainingSeconds) {
                  final minutes = remainingSeconds ~/ 60;
                  final seconds = remainingSeconds % 60;
                  return Text(
                    "Time Left: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                    style: textTh.bodySmall!.copyWith(color: Colors.red),
                  );
                },
                loading: () => const Text("Calculating time..."),
                error: (e, _) => const Text("Error with timer"),
              ),
          ],
        ),
        centerTitle: true,
        elevation: 6,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black87,
        backgroundColor: Colors.white,
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
          data: (questions) {
            questionsList = questions;
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 12,
              ),
              child: SizedBox(
                width: size.width,
                height: size.height * 0.8,
                child: Stack(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: pageViewController,
                        itemCount: questions.length,
                        itemBuilder: (_, index) {
                          var currentQuestion = questions[index];
                          if (index == (questions.length) - 1) {
                            allQuestionsAnswered = answersTrack.every(
                                (answer) => answer.selectedAnswer.isNotEmpty);
                          }
                          return SizedBox(
                            height: size.height * 0.66,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (currentQuestion.imageUrl != null)
                                    SizedBox(
                                      width: size.width * 0.8,
                                      height: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          height: 80,
                                          width: double.infinity,
                                          "${currentQuestion.imageUrl}.jpg", //?? "",
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Image.asset(
                                              fit: BoxFit.cover,
                                              "assets/images/applied_math.png",
                                              height: 80,
                                              width: double.infinity,
                                            );
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            // Show an error widget if the image failed to load

                                            return Image.asset(
                                                height: 80,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                "assets/images/applied_math.png");
                                          },
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      child: Text(
                                        "${questions.indexOf(currentQuestion)}. ${currentQuestion.questionText}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ...currentQuestion.options.map((op) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: SizedBox(
                                        width: size.width * 0.8,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Radio<String>(
                                              activeColor: AppColors.mainBlue,
                                              value: op,
                                              groupValue: answersTrack[index]
                                                  .selectedAnswer,
                                              onChanged: (value) {
                                                setState(() {
                                                  answersController
                                                      .selectAnswerForQuestion(
                                                          questions[index],
                                                          value!);
                                                });
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              op,
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
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
                                        layoutConfig.answerRevealed =
                                            !layoutConfig.answerRevealed;
                                        // this will trigger getMiddleExpandedFlex method.
                                      });
                                    },
                                    icon: const Icon(Icons.lightbulb),
                                    label: const Text("Reveal Solution"),
                                  ),
                                  if (layoutConfig.answerRevealed) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        currentQuestion.answer,
                                        style: textTh.bodyLarge,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8),
                                        width: size.width * 0.8,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                        child: Text(
                                          currentQuestion.explanation,
                                          style: textTh.bodySmall,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      child: SizedBox(
                        width: size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 4,
                              ),
                              onPressed: () {
                                if (currentQuestionImageTrack > 0) {
                                  setState(() {
                                    currentQuestionImageTrack--;
                                  });
                                  pageViewController.previousPage(
                                    duration: const Duration(milliseconds: 850),
                                    curve: Curves.decelerate,
                                  );
                                }
                              },
                              child: const Text(
                                "Previous",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.mainBlue,
                                elevation: 4,
                              ),
                              onPressed: () {
                                if (currentQuestionImageTrack <
                                    questions.length - 1) {
                                  setState(() {
                                    currentQuestionImageTrack++;
                                  });
                                  pageViewController.nextPage(
                                    duration: const Duration(milliseconds: 850),
                                    curve: Curves.decelerate,
                                  );
                                } else if (allQuestionsAnswered) {
                                  submitExam();
                                  int rightAnswers = 0;
                                  for (var qs in questions) {
                                    for (var ans in answersTrack) {
                                      if (qs.answer[0] == ans.selectedAnswer) {
                                        rightAnswers++;
                                      }
                                    }
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Exam Results'),
                                      content: Text(
                                        "You got $rightAnswers out of ${questions.length ?? 0} Questions right.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Incomplete Exam'),
                                      content: const Text(
                                          'Please answer all questions before submitting.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                currentQuestionImageTrack ==
                                        (questions.length) - 1
                                    ? 'Submit Exam'
                                    : 'Next',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    initializingPage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageNavController = ref.read(pageNavigationProvider.notifier);
      final examData =
          pageNavController.getArgumentsForPage(6) as Map<String, dynamic>;

      setState(() {
        examCourse = examData["exam course"]!;
        examYear = examData["exam year"]!;
        previousScreen = examData["previousScreen"]! as int;
        hasTimerOption = examData["hasTimerOption"]! as bool;

        for (var question in questionsList) {
          //int index = questions.indexOf(question);
          //correctAnswers[index] = question.answer;
          questionContainsImage.add(question.imageUrl == null);
        }
        initializingPage = false;

        pageViewController.addListener(trackLayoutConfig);
      });
    });
  }

  void submitExam() {}

  // this tracks the state of the layout config object
  // based on the current pageview index.
  // every time a new page comes it checks the question
  // that corresponds to that pageview and
  // modifies the image exists value based on the
  // whether that question has image. it also
  // toggles the answer revealed value of the layoutConfig
  // to false, and after that once reveal solution has been
  // pressed it will make it true. but for each new page
  // that comes the answerRevealed has to be reset to false.
  // cause whenever new screen comes the answer has to be hidden by default.
  void trackLayoutConfig() {
    double current = pageViewController.page ?? 0;
    int currentIndex = current.toInt();
    layoutConfig.imageExists = questionsList[currentIndex].imageUrl != null;
    layoutConfig.answerRevealed = false;
    print("current page: $currentIndex");
    print(
        "layout config=> answer revealed: ${layoutConfig.answerRevealed}, image exists: ${layoutConfig.imageExists}");
    print("the flex in question $middleExpandedFlex");

    // once setState is called,
    // this will trigger getMiddleExpandedFlex method.
    setState(() {});
  }
}
