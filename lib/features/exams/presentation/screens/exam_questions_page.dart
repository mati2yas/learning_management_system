import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/exams/presentation/screens/exam_questions_layout.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';

import '../../provider/timer_provider.dart';

class ExamQuestionsPage extends ConsumerStatefulWidget {
  const ExamQuestionsPage({super.key});

  @override
  ConsumerState<ExamQuestionsPage> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends ConsumerState<ExamQuestionsPage> {
  PageController pageViewController = PageController();
  PageNavigationController pageNavController = PageNavigationController();
  int middleExpandedFlex = 2;
  int currentQuestion = 0;
  String examTitle = "", examYear = "";
  Map<String, dynamic> examData = {};
  List<Question> questions = [];
  List<String> selectedAnswers = [];
  List<String> correctAnswers = [];
  List<bool> questionContainsImage = [];
  bool initializingPage = false;
  int currentQuestionImageTrack = 0;
  ScreenLayoutConfig layoutConfig = ScreenLayoutConfig();

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    final timerAsyncValue = ref.watch(examTimerProvider);
    middleExpandedFlex = questions.isNotEmpty &&
            questions[currentQuestionImageTrack].image == null
        ? 2
        : 4;

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
      body: initializingPage
          ? const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: AppColors.mainBlue,
                  strokeWidth: 5,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 12,
              ),
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Stack(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: size.height * 0.65,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: pageViewController,
                              itemCount: questions.length,
                              itemBuilder: (_, index) {
                                var currentQuestion = questions[index];
                                bool answerRevealed = middleExpandedFlex > 2;

                                return Column(
                                  children: [
                                    if (currentQuestion.image != null)
                                      SizedBox(
                                        width: size.width * 0.7,
                                        height: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            "assets/images/${currentQuestion.image}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${currentQuestion.sequenceOrder}. ${currentQuestion.question}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...currentQuestion.options.map((op) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: SizedBox(
                                          width: size.width * 0.55,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Radio<String>(
                                                activeColor: AppColors.mainBlue,
                                                value: op,
                                                groupValue:
                                                    selectedAnswers[index],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedAnswers[index] =
                                                        value!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                op,
                                                style: const TextStyle(
                                                    fontSize: 13),
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
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 200,
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
                                }
                              },
                              child: const Text(
                                "Next",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
        examTitle = examData["exam title"]!;
        examYear = examData["exam year"]!;
        questions = examData["questions"]! as List<Question>;

        correctAnswers = List.generate(questions.length, (index) => "");
        selectedAnswers = List.generate(questions.length, (index) => "");

        for (var question in questions) {
          int index = questions.indexOf(question);
          correctAnswers[index] = question.answer;
          questionContainsImage.add(question.image == null);
        }
        initializingPage = false;

        pageViewController.addListener(trackLayoutConfig);
      });
    });
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
    layoutConfig.imageExists = questions[currentIndex].image != null;
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
