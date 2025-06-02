import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/dialog_based_list_item_navigator.dart';
import 'package:lms_system/core/common_widgets/explanation_container.dart';
import 'package:lms_system/core/common_widgets/proportional_image.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/answers_holder.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExamSolutionsScreen extends StatefulWidget {
  final List<Question> questions;
  final List<AnswersHolder> answerHolders;
  const ExamSolutionsScreen({
    super.key,
    required this.questions,
    required this.answerHolders,
  });

  @override
  State<ExamSolutionsScreen> createState() => _ExamSolutionsScreenState();
}

class _ExamSolutionsScreenState extends State<ExamSolutionsScreen> {
  YoutubePlayerController ytCtrl = YoutubePlayerController(initialVideoId: "");
  PageController pageViewController = PageController();
  int questionsIndex = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CommonAppBar(titleText: "Exam Solutions"),
      backgroundColor: mainBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              width: size.width,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: pageViewController,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.answerHolders.length,
                itemBuilder: (_, index) {
                  final currentAnswerHolder = widget.answerHolders[index];
                  final currentQuestion = widget.questions.where((question) {
                    return question.answers ==
                            currentAnswerHolder.correctAnswers &&
                        question.id == currentAnswerHolder.questionId;
                  }).first;

                  //widget.questions[index];

                  if (currentQuestion.videoExplanationUrl != null) {
                    ytCtrl = YoutubePlayerController(
                        initialVideoId: currentQuestion.videoExplanationUrl!);
                  }
                  String multipleQuestionsIndicator = "";
                  if (currentAnswerHolder.correctAnswers.length > 1) {
                    multipleQuestionsIndicator = "(Select all that apply.)";
                  }
                  List<String> answerLetters = [
                    "A",
                    "B",
                    "C",
                    "D",
                    "E",
                    "F",
                    "G"
                  ];
                  List<String> selectedAnswerText = [];
                  List<String> correctAnswerText = [];

                  int answerIndex = 0;
                  for (var ans in currentAnswerHolder.correctAnswers) {
                    answerIndex = currentQuestion.options.indexOf(ans);
                    correctAnswerText
                        .add("${answerLetters[answerIndex]}. $ans");
                  }

                  for (var ans in currentAnswerHolder.selectedAnswers) {
                    answerIndex = currentQuestion.options.indexOf(ans);
                    selectedAnswerText
                        .add("${answerLetters[answerIndex]}. $ans");
                  }

                  if (currentQuestion.videoExplanationUrl != null) {
                    debugPrint(
                        "video url: ${currentQuestion.videoExplanationUrl}");
                    ytCtrl = YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                                currentQuestion.videoExplanationUrl!) ??
                            "");
                  }

                  return SizedBox(
                    height: size.height * 0.7,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            if (currentQuestion.imageUrl != null)
                              ProportionalImage(
                                  imageUrl: currentQuestion.imageUrl),
                            QuestionTextContainer(
                              questionNumber: index + 1,
                              question: currentQuestion.questionText,
                              textStyle: textTh.bodyLarge!
                                  .copyWith(fontFamily: "Roboto"),
                              maxWidth: size.width,
                            ),
                            Gap(),
                            ...currentQuestion.options.map(
                              (option) {
                                debugPrint(
                                    "option: $option, answers: [ ${correctAnswerText.join(",")} ]");
                                String letter = [
                                  "A",
                                  "B",
                                  "C",
                                  "D",
                                  "E",
                                  "F",
                                  "G",
                                  "H",
                                ][currentQuestion.options.indexOf(option)];
                                Color containerColor = mainBackgroundColor;

                                Widget? trailingIcon;
                                if (currentAnswerHolder.correctAnswers
                                    .contains(option)) {
                                  if (currentAnswerHolder.selectedAnswers
                                      .contains(option)) {
                                    containerColor = correctAnswerColor;
                                    trailingIcon = Center(
                                      child: Icon(Icons.check,
                                          size: 30, color: Colors.black),
                                    );
                                  }
                                } else {
                                  if (currentAnswerHolder.selectedAnswers
                                      .contains(option)) {
                                    containerColor = wrongAnswerColor;
                                    trailingIcon =
                                        Icon(Icons.close, color: Colors.red);
                                  }
                                }
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "$letter. $option",
                                          style:
                                              textTheme.titleMedium!.copyWith(
                                            letterSpacing: 0.5,
                                            // fontFamily: "Inter",
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (trailingIcon != null) trailingIcon,
                                    ],
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
                                const SizedBox(height: 12),
                                if (currentQuestion.explanation != "") ...[
                                  ExplanationContainer(
                                    explanation: currentQuestion.explanation,
                                    textStyle: textTh.bodyMedium!,
                                    maxWidth: size.width,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                if (currentQuestion.imageExplanationUrl !=
                                    null) ...[
                                  ProportionalImage(
                                      imageUrl:
                                          currentQuestion.imageExplanationUrl),
                                  const SizedBox(height: 12),
                                ],
                                if (currentQuestion.videoExplanationUrl !=
                                        null &&
                                    currentQuestion.videoExplanationUrl != "")
                                  YoutubePlayer(
                                    width: size.width,
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
                                      handleColor: AppColors.mainBlue
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              width: size.width,
                              height: 50,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DialogListItemNavigator(
                                    pageViewController: pageViewController,
                                    itemsCount: widget.answerHolders.length,
                                  ),
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
                                          duration:
                                              const Duration(milliseconds: 700),
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
                                          duration:
                                              const Duration(milliseconds: 700),
                                          curve: Curves.decelerate,
                                        );
                                      } else if (questionsIndex ==
                                          widget.questions.length - 1) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text(
                                      questionsIndex ==
                                              (widget.questions.length - 1)
                                          ? 'Back To Exams'
                                          : 'Next',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
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

  Future<double?> _getImageAspectRatio(String url) async {
    final image = Image.network(url);
    final completer = Completer<ImageInfo>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, _) {
        completer.complete(info);
      }),
    );

    final info = await completer.future;
    final width = info.image.width;
    final height = info.image.height;

    return width / height;
  }
}
