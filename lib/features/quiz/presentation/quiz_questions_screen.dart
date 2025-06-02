import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_dialog.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/common_widgets/proportional_image.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_layout.dart';
import 'package:lms_system/features/exams/provider/exam_timer_provider.dart';
import 'package:lms_system/features/quiz/presentation/quiz_solutions_screen.dart';
import 'package:lms_system/features/quiz/presentation/quiz_timer_provider.dart';
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
  bool hasTimerOption = false;

  PageNavigationController pageNavController = PageNavigationController();
  //PageNavigationController pageNavController = PageNavigationController();
  int middleExpandedFlex = 2;
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

  bool _timerStarted = false;
  bool _dialogShown = false;
  bool _timerInitializing = true;
  int questionsIndex = 0;

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.sizeOf(context);
    final timerAsyncValue = ref.watch(quizTimerProvider);

    final scoreManager = ref.watch(quizAnswersProvider);
    final answersController = ref.watch(quizAnswersProvider.notifier);

    final apiState = ref.watch(quizProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            //reset timer and the go back to previous screen
            ref.read(examTimerProvider.notifier).resetTimer(duration: 0);

            //pageNavController.navigateBack();
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
          ],
        ),
        bottom: hasTimerOption
            ? PreferredSize(
                preferredSize: Size(size.width, 25),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      _timerStarted
                          ? timerAsyncValue.when(
                              data: (remainingSeconds) {
                                final minutes = remainingSeconds ~/ 60;
                                final seconds = remainingSeconds % 60;
                                final minutesString = remainingSeconds == 0
                                    ? widget.quiz.duration
                                    : minutes.toString().padLeft(2, '0');
                                final secondsString =
                                    seconds.toString().padLeft(2, '0');

                                if (remainingSeconds == 0 &&
                                    !_dialogShown &&
                                    !_timerInitializing) {
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      if (!mounted) return;
                                      showCustomDialog(
                                        context: context,
                                        title: 'Time is up!',
                                        content: Text(
                                            "Time is up. Please submit your exam.",
                                            textAlign: TextAlign.center),
                                        onConfirm: () {
                                          Navigator.of(context).pop();
                                          submitExam(answersController);
                                        },
                                        onCancel: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Icons.timer,
                                        iconColor: Colors.red,
                                        confirmText: "Submit Exam",
                                        cancelText: 'Back',
                                      );

                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (_) => AlertDialog(
                                      //         content: const Text(
                                      //             "Time is up. Please submit your exam."),
                                      //         actions: [
                                      //           TextButton(
                                      //             onPressed: () {
                                      //               Navigator.of(context).pop();
                                      //             },
                                      //             child: const Text("Back to Quiz"),
                                      //           ),
                                      //           TextButton(
                                      //             onPressed: () {
                                      //               Navigator.of(context).pop();
                                      //               submitExam(answersController);
                                      //             },
                                      //             child: const Text("Submit Exam"),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     );
                                    },
                                  );
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.watch_later_outlined),
                                    Gap(),
                                    Text(
                                      "Time Left: $minutesString:$secondsString",
                                      style: textTh.titleMedium!.copyWith(
                                        color: remainingSeconds < 300
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const Text("Calculating time..."),
                              error: (e, _) => const Text("Error with timer"),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.watch_later_outlined),
                                Gap(
                                  width: 5,
                                ),
                                Text(
                                  "${widget.quiz.duration}:00",
                                  style: textTh.titleMedium!
                                      .copyWith(color: Colors.green),
                                ),
                              ],
                            ),
                      Gap(),
                      Visibility(
                        visible: !_timerStarted,
                        child: CustomButton(
                          isFilledButton: true,
                          buttonWidth: 50,
                          buttonHeight: 20,
                          buttonWidget: Text("Start",
                              style: textTheme.labelMedium!.copyWith(
                                letterSpacing: 0.5,
                                fontFamily: "Inter",
                                color: Colors.white,
                              )),
                          buttonAction: () {
                            Future.delayed((const Duration(seconds: 2)), () {
                              if (mounted) {
                                setState(() {
                                  _timerInitializing = false;
                                });
                              }
                            });
                            ref
                                .read(quizTimerProvider.notifier)
                                .startTimer(duration: widget.quiz.duration!);
                            _dialogShown = false;
                            if (mounted) {
                              setState(() {
                                _timerStarted = true;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
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
                  noDataMsg: "No questions have been added to this quiz yet.",
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
                            physics: NeverScrollableScrollPhysics(),
                            controller: pageViewController,
                            itemCount: questions.length,
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
                                child: ListView(
                                  children: [
                                    if (currentQuestionItem.imageUrl != null)
                                      ProportionalImage(
                                          imageUrl:
                                              currentQuestionItem.imageUrl),
                                    const SizedBox(width: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: QuestionTextContainer(
                                        questionNumber: index + 1,
                                        question:
                                            "${currentQuestionItem.text} $multipleQuestionsIndicator",
                                        textStyle: textTh.bodyMedium!,
                                        maxWidth: size.width * 0.9,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (currentQuestionItem.answers.length == 1)
                                      ...currentQuestionItem.options.map((op) {
                                        String letter = [
                                          "A",
                                          "B",
                                          "C",
                                          "D",
                                          "E",
                                          "F",
                                          "G",
                                          "H",
                                        ][currentQuestionItem.options
                                            .indexOf(op)];
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24),
                                          width: size.width * 0.9,
                                          height: 50,
                                          child: ListTile(
                                            leading: Radio<String>(
                                              activeColor: AppColors.mainBlue,
                                              value: op,
                                              groupValue: scoreManager
                                                  .answersHolders[index]
                                                  .selectedAnswers
                                                  .elementAtOrNull(0),
                                              onChanged: (value) {
                                                debugPrint(
                                                    "in ui page: groupValue: ${scoreManager.answersHolders[index].selectedAnswers.elementAtOrNull(0)}, current option's value: $op  selectedAnswer: $value");
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
                                                      qn: quiz.questions[index],
                                                      selectedAnswer: null,
                                                      radioButtonValue: op,
                                                    );
                                                  }
                                                });
                                              },
                                            ),
                                            title: Text(
                                              "$letter. $op",
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
                                          String letter = [
                                            "A",
                                            "B",
                                            "C",
                                            "D",
                                            "E",
                                            "F",
                                            "G",
                                            "H",
                                          ][currentQuestionItem.options
                                              .indexOf(op)];
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24),
                                            child: ListTile(
                                              leading: Checkbox(
                                                activeColor: AppColors.mainBlue,
                                                value: scoreManager
                                                    .answersHolders[index]
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
                                                "$letter. $op",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    const SizedBox(height: 35),
                                    SizedBox(
                                      width: size.width,
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 4,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (hasTimerOption &&
                                                  !_timerStarted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "You need to start the quiz first")));
                                                return;
                                              }
                                              if (currentQuestionImageTrack >
                                                  0) {
                                                setState(() {
                                                  currentQuestionImageTrack--;
                                                });
                                                pageViewController.previousPage(
                                                  duration: const Duration(
                                                      milliseconds: 700),
                                                  curve: Curves.decelerate,
                                                );
                                              }
                                            },
                                            child: const Text(
                                              "Previous",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () {
                                              //submitExam(answersController);

                                              if (hasTimerOption &&
                                                  !_timerStarted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "You need to start the quiz first")));
                                                return;
                                              }
                                              answersController.getScore();

                                              showCustomDialog(
                                                context: context,
                                                title: 'Exam Result !',
                                                content: SizedBox(
                                                  height: 80,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    spacing: 12,
                                                    children: [
                                                      Text(
                                                        "Attempted Questions: ${scoreManager.scoreValue.attemptedQuestions}",
                                                        style: textTh.bodyLarge!
                                                            .copyWith(
                                                          color: AppColors
                                                              .mainBlue,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Score: ${scoreManager.scoreValue.score} / ${scoreManager.scoreValue.totalQuestions}",
                                                        style: textTh.bodyLarge!
                                                            .copyWith(
                                                          color: AppColors
                                                              .mainBlue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                onConfirm: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          QuizSolutionsScreen(
                                                        myAnswers: scoreManager
                                                            .answersHolders,
                                                        questions: questions,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                // onCancel: () {
                                                //   timerController.stopTimer();
                                                //   Navigator.of(context).pop();
                                                // },
                                                icon: Icons.done,
                                                iconColor: Colors.green,
                                                confirmText: "See Solutions",
                                                cancelText: 'back',
                                              );

                                              // showDialog(
                                              //   context: context,
                                              //   builder: (context) =>
                                              //       AlertDialog(
                                              //     title:
                                              //         const Text('Exam Result'),
                                              //     content: SizedBox(
                                              //       height: 80,
                                              //       child: Column(
                                              //         crossAxisAlignment:
                                              //             CrossAxisAlignment
                                              //                 .start,
                                              //         spacing: 12,
                                              //         children: [
                                              //           Text(
                                              //             "Attempted Questions: ${scoreManager.scoreValue.attemptedQuestions}",
                                              //             style: textTh
                                              //                 .bodyMedium!
                                              //                 .copyWith(
                                              //               fontWeight:
                                              //                   FontWeight.w600,
                                              //               color: AppColors
                                              //                   .mainBlue,
                                              //             ),
                                              //           ),
                                              //           Text(
                                              //             "Score: ${scoreManager.scoreValue.score} / ${scoreManager.scoreValue.totalQuestions}",
                                              //             style: textTh
                                              //                 .bodyMedium!
                                              //                 .copyWith(
                                              //               fontWeight:
                                              //                   FontWeight.w600,
                                              //               color: AppColors
                                              //                   .mainBlue,
                                              //             ),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ),
                                              //     actions: [
                                              //       TextButton(
                                              //         onPressed: () {
                                              //           Navigator.pop(context);
                                              //           Navigator.of(context)
                                              //               .push(
                                              //             MaterialPageRoute(
                                              //               builder: (ctx) =>
                                              //                   QuizSolutionsScreen(
                                              //                 myAnswers:
                                              //                     scoreManager
                                              //                         .answersHolders,
                                              //                 questions:
                                              //                     questions,
                                              //               ),
                                              //             ),
                                              //           );
                                              //         },
                                              //         child: const Text(
                                              //             "See Solutions"),
                                              //       ),
                                              //       TextButton(
                                              //         onPressed: () =>
                                              //             Navigator.of(context)
                                              //                 .pop(),
                                              //         child: const Text('OK'),
                                              //       ),
                                              //     ],
                                              //   ),
                                              // );
                                            },
                                            child: const Text(
                                              'Submit',
                                              style: TextStyle(
                                                  color: AppColors.mainBlue),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 4,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (hasTimerOption &&
                                                  !_timerStarted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "You need to start the quiz first")));
                                                return;
                                              }
                                              if (currentQuestionImageTrack <
                                                  (questions.length) - 1) {
                                                setState(() {
                                                  currentQuestionImageTrack++;
                                                });
                                                pageViewController.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 700),
                                                  curve: Curves.decelerate,
                                                );
                                              }
                                            },
                                            child: const Text(
                                              'Next',
                                              style: TextStyle(
                                                  color: AppColors.mainBlue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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

    hasTimerOption = widget.quiz.duration != null;
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

  void submitExam(AnswersNotifier answersController) {
    answersController.getScore();
  }

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
