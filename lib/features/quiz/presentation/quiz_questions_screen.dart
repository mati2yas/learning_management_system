import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_layout.dart';
import 'package:lms_system/features/exams/provider/timer_provider.dart';
import 'package:lms_system/features/quiz/presentation/quiz_solutions_screen.dart';
import 'package:lms_system/features/quiz/provider/quiz_answers_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../model/quiz_model.dart';
import '../provider/quiz_provider.dart';

class QuizQuestionsPage extends ConsumerStatefulWidget {
  final Quiz quiz;
  const QuizQuestionsPage({
    super.key,
    required this.quiz,
  });

  @override
  ConsumerState<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends ConsumerState<QuizQuestionsPage> {
  PageController pageViewController = PageController();

  PageNavigationController pageNavController = PageNavigationController();
  //PageNavigationController pageNavController = PageNavigationController();
  int middleExpandedFlex = 2;
  //int currentQuestion = 0;
  int previousScreen =
      1; // we use wrapper screen index to track which screen we navigated from
  String examTitle = "", examYear = "";
  bool allQuestionsAnswered = false;
  //Map<String, dynamic> examData = {};
  List<QuizQuestion> questions = [];
  List<String> selectedAnswers = [];
  List<String> correctAnswers = [];
  List<bool> questionContainsImage = [];
  bool initializingPage = false;
  int currentQuestionImageTrack = 0;
  ScreenLayoutConfig layoutConfig = ScreenLayoutConfig();

  int questionsIndex = 0;

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.sizeOf(context);
    final timerAsyncValue = ref.watch(examTimerProvider);

    final answersTrack = ref.watch(quizAnswersProvider);
    final answersController = ref.watch(quizAnswersProvider.notifier);

    final apiState = ref.watch(quizProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //reset timer and the go back to previous screen
            ref
                .read(examTimerProvider.notifier)
                .resetTimer(duration: widget.quiz.duration);
            pageNavController.navigatePage(previousScreen);
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Column(
          children: [
            Text(
              "$examYear $examTitle",
              style: textTh.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
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
        error: (error, stack) => AsyncErrorWidget(
          errorMsg: error.toString(),
          callback: () {},
        ),
        data: (quiz) {
          return (quiz.questions.isEmpty)
              ? NoDataWidget(
                  noDataMsg: "There are no questions for this quiz.",
                  callback: () async {
                    await ref.refresh(quizProvider.notifier).fetchQuizData();
                  },
                )
              : Padding(
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
                            onPageChanged: (index) {
                              debugPrint("current page index: $index");
                              setState(() {
                                questionsIndex = index;
                              });
                              if (index == (quiz.questions.length)) {
                                setState(() {
                                  allQuestionsAnswered = answersTrack.every(
                                    (answer) =>
                                        answer.selectedAnswers.isNotEmpty,
                                  );
                                });

                                debugPrint(
                                    "all questions answered? $allQuestionsAnswered");
                              }
                            },
                            itemBuilder: (_, index) {
                              QuizQuestion currentQuestionItem =
                                  questions[index];
                              String multipleQuestionsIndicator = "";
                              if ((currentQuestionItem.answers.length ?? 0) >
                                  1) {
                                multipleQuestionsIndicator =
                                    "(Select all that apply.)";
                              }

                              return SizedBox(
                                height: size.height * 0.66,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      if (currentQuestionItem.imageUrl != null)
                                        SizedBox(
                                          width: size.width * 0.8,
                                          height: 150,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              height: 80,
                                              width: double.infinity,
                                              "${currentQuestionItem.imageUrl}.jpg", //?? "",
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Image.asset(
                                                  fit: BoxFit.cover,
                                                  "assets/images/error-image.png",
                                                  height: 80,
                                                  width: double.infinity,
                                                );
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                // Show an error widget if the image failed to load

                                                return Image.asset(
                                                    height: 80,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    "assets/images/error-image.png");
                                              },
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: QuestionTextContainer(
                                          question:
                                              "${index + 1}. ${currentQuestionItem.text} $multipleQuestionsIndicator",
                                          textStyle: textTh.bodyMedium!,
                                          maxWidth: size.width * 0.75,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (currentQuestionItem.answers.length ==
                                          1)
                                        ...currentQuestionItem.options
                                            .map((op) {
                                          return SizedBox(
                                            width: size.width * 0.8,
                                            height: 50,
                                            child: ListTile(
                                              leading: Radio<String>(
                                                activeColor: AppColors.mainBlue,
                                                value: op,
                                                groupValue: answersTrack[index]
                                                    .selectedAnswers
                                                    .elementAtOrNull(0),
                                                onChanged: (value) {
                                                  debugPrint(
                                                      "in ui page: groupValue: ${answersTrack[index].selectedAnswers.elementAtOrNull(0)}, current option's value: $op  selectedAnswer: $value");
                                                  setState(() {
                                                    if (value != null) {
                                                      answersController
                                                          .selectAnswerForQuestion(
                                                        qn: questions[index],
                                                        selectedAnswer: value,
                                                        radioButtonValue: op,
                                                      );
                                                    } else {
                                                      // this is the logic for tracking the state when an
                                                      // option is unselected.
                                                      // in this one we send selectedAnswer as null
                                                      // intentionally, to track the state where this option is
                                                      // unselected and thus remove it from the state if it
                                                      // previously existed. and that's why we also send
                                                      // radioButtonValue, we check if that value already
                                                      // exists in the state and then remove it.
                                                      answersController
                                                          .selectAnswerForQuestion(
                                                        qn: quiz
                                                            .questions[index],
                                                        selectedAnswer: null,
                                                        radioButtonValue: op,
                                                      );
                                                    }
                                                  });
                                                },
                                              ),
                                              title: Text(
                                                op,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                      else if (currentQuestionItem
                                              .answers.length >
                                          1)
                                        ...currentQuestionItem.options.map(
                                          (op) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: ListTile(
                                                leading: Checkbox(
                                                  activeColor:
                                                      AppColors.mainBlue,
                                                  value: answersTrack[index]
                                                      .selectedAnswers
                                                      .contains(op),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (value ?? false) {
                                                        answersController
                                                            .selectAnswerForQuestion(
                                                          qn: questions[index],
                                                          selectedAnswer: op,
                                                          radioButtonValue: op,
                                                        );
                                                      } else {
                                                        answersController
                                                            .selectAnswerForQuestion(
                                                          qn: questions[index],
                                                          selectedAnswer: null,
                                                          radioButtonValue: op,
                                                        );
                                                      }
                                                    });
                                                  },
                                                ),
                                                title: Text(
                                                  op,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 80,
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
                                        duration:
                                            const Duration(milliseconds: 850),
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
                                    allQuestionsAnswered = answersTrack.every(
                                        (answer) =>
                                            answer.selectedAnswers.isNotEmpty);

                                    debugPrint(
                                        "all questions answered? $allQuestionsAnswered");
                                    if (currentQuestionImageTrack <
                                        (questions.length) - 1) {
                                      setState(() {
                                        currentQuestionImageTrack++;
                                      });
                                      pageViewController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 700),
                                        curve: Curves.decelerate,
                                      );
                                    } else if (allQuestionsAnswered) {
                                      submitExam();
                                      int rightAnswers =
                                          answersController.getScore();

                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Quiz Results'),
                                          content: Text(
                                            "You got $rightAnswers out of ${questions.length ?? 0} Questions right.",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        QuizSolutionsScreen(
                                                      questions: questions,
                                                      myAnswers: answersTrack,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child:
                                                  const Text("See Solutions"),
                                            ),
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
                                          title: const Text('Quiz Incomplete'),
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
                                        ? 'Submit Quiz'
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
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializingPage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // pageNavController = ref.read(pageNavigationProvider.notifier);
      // final examData =
      //     pageNavController.getArgumentsForPage(6) as Map<String, dynamic>;

      setState(() {
        examTitle = widget.quiz.title ?? "Take Quiz";
        //examYear = examData["exam year"]!;
        questions = widget.quiz.questions;

        correctAnswers = List.generate((questions.length ?? 0),
            (index) => questions[index].answers.first ?? "no answer");
        selectedAnswers = List.generate((questions.length ?? 1), (index) => "");

        for (var question in questions) {
          int index = questions.indexOf(question);
          correctAnswers[index] = question.answers.first;
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
    layoutConfig.imageExists =
        questions[currentIndex].imageExplanationUrl != null;
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
