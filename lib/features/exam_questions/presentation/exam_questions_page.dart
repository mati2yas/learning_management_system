import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/features/exam_questions/presentation/exam_solutions_screen.dart';
import 'package:lms_system/features/exam_questions/provider/exam_answers_provider.dart';
import 'package:lms_system/features/exam_questions/provider/exam_questions_provider.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_layout.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../exams/provider/exam_timer_provider.dart';

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
  int previousScreen =
      3; // we use wrapper screen index to track which screen we navigated from
  String examCourse = "", examYear = "", examChapter = "";
  Map<String, dynamic> examData = {};
  List<Question> questionsList = [];
  int timerDuration = 0;

  int currentQuestionIndexTrack = 0;
  ScreenLayoutConfig layoutConfig = ScreenLayoutConfig();

  bool hasTimerOption = false;
  bool _timerStarted = false;
  bool _dialogShown = false;
  bool _timerInitializing = true;
  final bool _timerEnded = false;
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;

    debugPrint(
        "in build: hasTimerOption: $hasTimerOption, timer started: $_timerStarted");

    final scoreManager = ref.watch(examAnswersProvider);
    final answersController = ref.watch(examAnswersProvider.notifier);
    var size = MediaQuery.sizeOf(context);
    final timerAsyncValue = ref.watch(examTimerProvider);
    final timerController = ref.watch(examTimerProvider.notifier);

    final apiState = ref.watch(examQuestionsApiProvider);
    ("curentquestionindextrack: $currentQuestionIndexTrack");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // reset timer and the go back to previous screen
            //ref.read(examTimerProvider.notifier).resetTimer(duration: 0);
            //pageNavController.navigatePage(previousScreen);
            pageNavController.navigateBack();
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
            //if (hasTimerOption)
          ],
        ),
        centerTitle: true,
        elevation: 6,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black87,
        backgroundColor: Colors.white,
        bottom: hasTimerOption
            ? PreferredSize(
                preferredSize: Size(size.width, 30),
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
                              String minutesString = "";

                              if (remainingSeconds == 0) {
                                if (!_timerEnded) {
                                  minutesString = "$timerDuration";
                                } else {
                                  minutesString = "00";
                                }
                              } else {
                                minutesString =
                                    minutes.toString().padLeft(2, '0');
                              }

                              final secondsString =
                                  seconds.toString().padLeft(2, '0');
                              debugPrint(
                                  "minutes: $minutesString, seconds: $secondsString");

                              if (remainingSeconds == 0 &&
                                  !_dialogShown &&
                                  !_timerInitializing) {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    if (!mounted) return;

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content:
                                            const Text("Exam Time is over."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              timerController.stopTimer();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Ok"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              submitExam(answersController);
                                            },
                                            child: const Text("Submit Exam"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }

                              return Text(
                                "Time Left: $minutesString:$secondsString",
                                style: textTh.bodyMedium!.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                            loading: () => const Text("Calculating time..."),
                            error: (e, _) => const Text("Error with timer"),
                          )
                        : Text(
                            "$timerDuration:00",
                            style:
                                textTh.bodySmall!.copyWith(color: Colors.green),
                          ),
                    Visibility(
                      visible: !_timerStarted,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.mainBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          Future.delayed((const Duration(seconds: 2)), () {
                            if (mounted) {
                              setState(() {
                                _timerInitializing = false;
                              });
                            }
                          });
                          ref
                              .read(examTimerProvider.notifier)
                              .startTimer(duration: timerDuration);
                          _dialogShown = false;
                          if (mounted) {
                            setState(() {
                              _timerStarted = true;
                            });
                          }
                        },
                        child: Text(
                          "Start",
                          style: textTh.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : null,
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
          callback: () async {
            await ref
                .refresh(examQuestionsApiProvider.notifier)
                .fetchQuestions();
          },
        ),
        data: (questions) {
          questionsList = questions;
          return questions.isEmpty
              ? NoDataWidget(
                  noDataMsg: "There are no Questions for this Exam yet.",
                  callback: () async {
                    await ref
                        .refresh(examQuestionsApiProvider.notifier)
                        .fetchQuestions();
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 6,
                  ),
                  child: SizedBox(
                    width: size.width,
                    height: size.height - 60, // 60 height of bottom navbar
                    child: PageView.builder(
                      allowImplicitScrolling: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      controller: pageViewController,
                      itemCount: questions.length,
                      itemBuilder: (_, index) {
                        var currentQuestion = questions[index];

                        debugPrint(
                            "current image url: ${currentQuestion.imageUrl}");
                        String multipleQuestionsIndicator = "";
                        if (currentQuestion.answers.length > 1) {
                          multipleQuestionsIndicator =
                              "(Select all that apply)";
                        }

                        return SizedBox(
                          height: size.height * 0.7,
                          child: ListView(
                            children: [
                              if (currentQuestion.imageUrl != null)
                                SizedBox(
                                  width: size.width * 0.9,
                                  height: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      height: 80,
                                      width: double.infinity,
                                      // UtilFunctions()
                                      //     .determineProperImageUrl(
                                      //         currentQuestion.imageUrl ??
                                      //             ""),
                                      currentQuestion.imageUrl ?? "",
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
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
                                      errorBuilder: (BuildContext context,
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
                              QuestionTextContainer(
                                question:
                                    "${questions.indexOf(currentQuestion) + 1}. ${currentQuestion.questionText} $multipleQuestionsIndicator",
                                textStyle: textTh.bodyMedium!,
                                maxWidth: size.width,
                              ),
                              const SizedBox(height: 10),
                              if (currentQuestion.answers.length == 1)
                                ...currentQuestion.options.map((op) {
                                  return ListTile(
                                    leading: Radio<String>(
                                      activeColor: AppColors.mainBlue,
                                      value: op,
                                      groupValue: scoreManager
                                          .answersHolders[index].selectedAnswers
                                          .elementAtOrNull(0),
                                      onChanged: (value) {
                                        debugPrint(
                                            "in ui page: groupValue: ${scoreManager.answersHolders[index].selectedAnswers.elementAtOrNull(0)}, current option's value: $op  selectedAnswer: $value");
                                        setState(
                                          () {
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
                                                qn: questions[index],
                                                selectedAnswer: null,
                                                radioButtonValue: op,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    title: Text(
                                      op,
                                      style: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                })
                              else if (currentQuestion.answers.length > 1)
                                ...currentQuestion.options.map(
                                  (op) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
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
                                          op,
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              const Spacer(),
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
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (hasTimerOption && !_timerStarted) {
                                          return;
                                        }
                                        if (currentQuestionIndexTrack > 0) {
                                          setState(() {
                                            currentQuestionIndexTrack--;
                                          });
                                          debugPrint(
                                              "current question index: $currentQuestionIndexTrack, questions length: ${questions.length}");
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
                                            color: AppColors.mainBlue),
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

                                        if (hasTimerOption && !_timerStarted) {
                                          return;
                                        }
                                        answersController.getScore();

                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Exam Results'),
                                            content: SizedBox(
                                              height: 80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 12,
                                                children: [
                                                  Text(
                                                    "Attempted Questions: ${scoreManager.scoreValue.attemptedQuestions}",
                                                    style: textTh.bodyMedium!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.mainBlue,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Score: ${scoreManager.scoreValue.score} / ${scoreManager.scoreValue.totalQuestions}",
                                                    style: textTh.bodyMedium!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors.mainBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          ExamSolutionsScreen(
                                                        answerHolders:
                                                            scoreManager
                                                                .answersHolders,
                                                        questions: questions,
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
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (hasTimerOption && !_timerStarted) {
                                          return;
                                        }
                                        if (currentQuestionIndexTrack <
                                            (questions.length - 1)) {
                                          setState(() {
                                            currentQuestionIndexTrack++;
                                          });
                                          debugPrint(
                                              "current question index: $currentQuestionIndexTrack, questions length: ${questions.length}");
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
                              const SizedBox(height: 100),
                            ],
                          ),
                        );
                      },
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageNavController = ref.read(pageNavigationProvider.notifier);
      final examData =
          pageNavController.getArgumentsForPage(6) as Map<String, dynamic>;
      debugPrint(
          "does it have timer option? ${examData[AppStrings.hasTimerOptionKey]}");

      setState(() {
        examCourse = examData[AppStrings.examCourseKey]! as String;
        timerDuration = examData[AppStrings.timerDurationKey]! as int;
        examYear = examData[AppStrings.examYearKey]! as String;
        previousScreen = examData[AppStrings.previousScreenKey]! as int;
        hasTimerOption = examData[AppStrings.hasTimerOptionKey]! as bool;
        pageViewController.addListener(trackLayoutConfig);
      });
    });
    debugPrint("in addPostframe: hasTimerOption: $hasTimerOption");
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
    layoutConfig.imageExists = questionsList[currentIndex].imageUrl != null;
    layoutConfig.answerRevealed = false;
    debugPrint("current page: $currentIndex");
    // debugPrint(
    //     "layout config=> answer revealed: ${layoutConfig.answerRevealed}, image exists: ${layoutConfig.imageExists}");
    // debugPrint("the flex in question $middleExpandedFlex");

    // once setState is called,
    // this will trigger getMiddleExpandedFlex method.
    setState(() {});
  }
}
