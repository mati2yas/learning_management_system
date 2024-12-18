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
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    // Store selected answers
    print("questions length: ${questions.length}");

    middleExpandedFlex =
        questions[currentQuestionImageTrack].image == null ? 2 : 4;
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
          : SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
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
                          SizedBox(
                            height: 30,
                            width: size.width,
                            child: ListView.separated(
                              itemCount: questions.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    // color: correctAnswers[index] ==
                                    //         selectedAnswers[index]
                                    //     ? Colors.green
                                    //     : AppColors.mainGrey,
                                    color: AppColors.mainGrey,
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                );
                              },
                              separatorBuilder: (_, index) =>
                                  const SizedBox(width: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: middleExpandedFlex,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: pageViewController,
                      itemCount: questions.length,
                      itemBuilder: (_, index) {
                        var currentQuestion = questions[index];
                        bool answerRevealed = false;
                        return SizedBox(
                          width: size.width * 0.8,
                          child: Column(
                            children: [
                              if (currentQuestion.image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/${currentQuestion.image}",
                                    width: size.width * 0.7,
                                    height: 250,
                                  ),
                                ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                    middleExpandedFlex =
                                        modifyMiddleExpandedFlex(
                                      middleExpandedFlex,
                                      questions[index].image != null,
                                    );
                                  });
                                },
                                label: const Text("Reveal Solution"),
                              ),
                              if (middleExpandedFlex == 4)
                                Text(questions[index].explanation),
                              const SizedBox(height: 15),
                              if (answerRevealed) ...[
                                const SizedBox(height: 10),
                                Text(currentQuestion.explanation),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 2,
                                      color: AppColors.darkerGrey,
                                    ),
                                  ),
                                  child: Text(currentQuestion.explanation),
                                )
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: size.width * 0.6,
                      alignment: Alignment.topCenter,
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
                              setState(() {
                                if (currentQuestionImageTrack >
                                    questions.length) {
                                  currentQuestionImageTrack -= 1;
                                }
                              });
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
                              setState(() {
                                if (currentQuestionImageTrack <
                                    questions.length) {
                                  currentQuestionImageTrack += 1;
                                }
                              });
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
                    ),
                  ),
                ],
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

        // initialize correctAnswers and selectedAnswers as
        // lists of empty strings with length the same as
        // the number of questions.
        correctAnswers = List.generate(questions.length, (index) => "");
        selectedAnswers = List.generate(questions.length, (index) => "");

        for (var question in questions) {
          // save the correct answers.
          int index = questions.indexOf(question);
          correctAnswers[index] = question.answer;

          // track whether each question contains image
          questionContainsImage.add(question.image == null);
        }
        initializingPage = false;
      });
    });
  }

  int modifyMiddleExpandedFlex(int middleExpandedFlex, bool pictureExists) {
    if (pictureExists) {
      // in case of a picture existing, middle expanded
      // flex wil either be 4 or 6. 6 means answer revealed
      // and 4 means no answer revealed.
      // if it was 4 make it 6, if 6 make it 4
      if (middleExpandedFlex == 4) {
        middleExpandedFlex = 6;
      } else if (middleExpandedFlex == 6) {
        middleExpandedFlex = 4;
      }
    } else {
      // in case of a picture existing, middle expanded
      // flex wil either be 2 or 4. 4 means answer
      // revealed and 2 means no answer revealed.
      // if it was 2 make it 4, if 4 make it 2
      if (middleExpandedFlex == 2) {
        middleExpandedFlex = 4;
      } else if (middleExpandedFlex == 4) {
        middleExpandedFlex = 2;
      }
    }
    return middleExpandedFlex;
  }
}
