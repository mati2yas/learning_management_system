import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/explanation_container.dart';
import 'package:lms_system/core/common_widgets/proportional_image.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/quiz/model/quiz_model.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/answers_holder.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class QuizSolutionsScreen extends StatefulWidget {
  List<QuizQuestion> questions;
  List<AnswersHolder> myAnswers;
  QuizSolutionsScreen({
    super.key,
    this.questions = const [],
    this.myAnswers = const [],
  });

  @override
  State<QuizSolutionsScreen> createState() => _QuizSolutionsScreenState();
}

class _QuizSolutionsScreenState extends State<QuizSolutionsScreen> {
  YoutubePlayerController ytCtrl = YoutubePlayerController(initialVideoId: "");
  PageController pageViewController = PageController();
  int questionsIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      appBar: CommonAppBar(titleText: "Quiz Solutions"),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pageViewController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.questions.length,
          itemBuilder: (_, index) {
            final currentAnswerHolder = widget.myAnswers[index];
            final currentQuestion = widget.questions
                .where((question) {
                  return question.answers ==
                          currentAnswerHolder.correctAnswers &&
                      question.id == currentAnswerHolder.questionId;
                })
                .toList()
                .first;
            String multipleQuestionsIndicator = "";
            if (currentQuestion.answers.length > 1) {
              multipleQuestionsIndicator = "(Select all that apply.)";
            }
            List<String> answerLetters = ["A", "B", "C", "D", "E", "F", "G"];
            List<String> answerText = [];
            List<String> myAnswersText = [];

            int answerIndex = 0;

            for (var ans in currentQuestion.answers) {
              answerIndex = currentQuestion.options.indexOf(ans);
              answerText.add("${answerLetters[answerIndex]}. $ans");
            }
            for (var ans in widget.myAnswers[index].selectedAnswers) {
              answerIndex = currentQuestion.options.indexOf(ans);
              //String answerTxt = ans.;
              myAnswersText.add("${answerLetters[answerIndex]}. $ans");
            }

            if (currentQuestion.videoExplanationUrl != null) {
              debugPrint("video url: ${currentQuestion.videoExplanationUrl}");
              ytCtrl = YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(
                          currentQuestion.videoExplanationUrl!) ??
                      "");
            }

            return SizedBox(
              height: size.height * 0.7,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 20),
                  child: Column(
                    spacing: 12,
                    children: [
                      QuestionTextContainer(
                        questionNumber: index + 1,
                        question: currentQuestion.text,
                        textStyle: textTh.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxWidth: size.width * 0.9,
                      ),
                      ...currentQuestion.options.map(
                        (op) {
                          Color containerColor = mainBackgroundColor;
                          

                          if (currentAnswerHolder.correctAnswers.contains(op)) {
                            if (currentAnswerHolder.selectedAnswers
                                .contains(op)) {
                              containerColor = correctAnswerColor;
                            }
                          } else {
                            if (currentAnswerHolder.selectedAnswers
                                .contains(op)) {
                              containerColor = wrongAnswerColor;
                            }
                          }
                          String letter = [
                            "A",
                            "B",
                            "C",
                            "D",
                            "E",
                            "F",
                            "G",
                            "H",
                          ][currentQuestion.options.indexOf(op)];
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "$letter. $op",
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mainBlue,
                              ),
                            ),
                          );
                        },
                      ),
                      ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 3),
                        title: Text(
                          "Explanation",
                          style: textTheme.titleMedium!.copyWith(
                              letterSpacing: 0.5,
                              fontFamily: "Inter",
                              color: AppColors.mainBlue2,
                              overflow: TextOverflow.ellipsis),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: BorderSide(
                              color: Colors
                                  .transparent), // 🔥 Removes collapsed border
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                              color: AppColors
                                  .mainBlue2), // 🔥 Removes expanded border
                        ),
                        children: [
                          if (!<dynamic>[null, ""]
                              .contains(currentQuestion.textExplanation)) ...[
                            ExplanationContainer(
                              explanation: currentQuestion.textExplanation,
                              textStyle: textTh.bodyMedium!,
                              maxWidth: size.width,
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (currentQuestion.imageExplanationUrl != null) ...[
                            ProportionalImage(
                                imageUrl: currentQuestion.imageExplanationUrl),
                            const SizedBox(height: 12),
                          ],
                          if (currentQuestion.videoExplanationUrl != null)
                            YoutubePlayer(
                              width: size.width * 0.9,
                              aspectRatio: 16 / 9,
                              bottomActions: [
                                const CurrentPosition(),
                                const ProgressBar(isExpanded: true),
                                const CurrentPosition(),
                                FullScreenButton(
                                  controller: ytCtrl,
                                ),
                              ],
                              controller: ytCtrl,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: AppColors.mainBlue,
                              progressColors: ProgressBarColors(
                                playedColor: AppColors.mainBlue,
                                handleColor:
                                    AppColors.mainBlue.withValues(alpha: 0.6),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12),
                      SizedBox(
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
                                if (questionsIndex > 0) {
                                  setState(() {
                                    questionsIndex--;
                                  });
                                  debugPrint(
                                      "current question index: $questionsIndex, questions length: ${widget.questions.length}");
                                  pageViewController.previousPage(
                                    duration: const Duration(milliseconds: 700),
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
                                if (questionsIndex <
                                    (widget.questions.length - 1)) {
                                  setState(() {
                                    questionsIndex++;
                                  });
                                  debugPrint(
                                      "current question index: $questionsIndex, questions length: ${widget.questions.length}");
                                  pageViewController.nextPage(
                                    duration: const Duration(milliseconds: 700),
                                    curve: Curves.decelerate,
                                  );
                                } else if (questionsIndex ==
                                    widget.questions.length - 1) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                questionsIndex == (widget.questions.length - 1)
                                    ? 'Back To Quizzes'
                                    : 'Next',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    ytCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    String url;
    url = "";
    ytCtrl = YoutubePlayerController(
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
      ),
      initialVideoId: YoutubePlayer.convertUrlToId(url) ?? "",
    );
    ytCtrl.addListener(() {});
  }
}
