import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/explanation_container.dart';
import 'package:lms_system/core/common_widgets/proportional_image.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
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

  // IMPORTANT: Ensure this list is large enough for your max options (e.g., up to 'H' or more)
  List<String> answerLetters = ["A", "B", "C", "D", "E", "F", "G", "H"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CommonAppBar(titleText: "Exam Solutions"),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: pageViewController,
          itemCount: widget.answerHolders.length,
          itemBuilder: (_, index) {
            final currentAnswerHolder = widget.answerHolders[index];
            final currentQuestion = widget.questions.where((question) {
              return question.id == currentAnswerHolder.questionId;
            }).first;

            if (currentQuestion.videoExplanationUrl != null) {
              ytCtrl = YoutubePlayerController(
                  initialVideoId: currentQuestion.videoExplanationUrl!);
            }
            String multipleQuestionsIndicator = "";
            if (currentAnswerHolder.correctAnswers.length > 1) {
              multipleQuestionsIndicator = "(Select all that apply.)";
            }

            List<String> selectedAnswerText = [];
            List<String> correctAnswerText = [];

            // Helper to normalize text for comparison
            // This is a minimal version, assuming options are clean, but answers might not be.
            // If your Question model already normalizes answers/options as discussed previously,
            // you might not need this helper here, as `currentQuestion.options` and
            // `currentAnswerHolder.correctAnswers`/`selectedAnswers` would already be normalized.
            // However, keeping it here for safety if the Question model isn't fully normalized yet.
            String _normalizeForComparison(String text) {
              final RegExp prefixPattern = RegExp(r'^[a-zA-Z]\.\s*');
              String processedText = text;
              if (prefixPattern.hasMatch(processedText)) {
                processedText =
                    processedText.replaceFirst(prefixPattern, '').trim();
              }
              return processedText.toLowerCase();
            }

            // Populate correctAnswerText
            for (var ans in currentAnswerHolder.correctAnswers) {
              String normalizedAns = _normalizeForComparison(ans);
              int answerIndex = -1;
              for (int i = 0; i < currentQuestion.options.length; i++) {
                if (_normalizeForComparison(currentQuestion.options[i]) ==
                    normalizedAns) {
                  answerIndex = i;
                  break;
                }
              }

              // --- Change here: Only add if a valid index is found ---
              if (answerIndex != -1 && answerIndex < answerLetters.length) {
                correctAnswerText.add("${answerLetters[answerIndex]}. $ans");
              }
              // --- Removed debugPrint and else branch for "error" placeholder ---
            }

            // Populate selectedAnswerText
            for (var ans in currentAnswerHolder.selectedAnswers) {
              // Removed the debugPrint for empty list as it was mostly for debugging this specific issue.
              String normalizedAns = _normalizeForComparison(ans);
              int answerIndex = -1;
              for (int i = 0; i < currentQuestion.options.length; i++) {
                if (_normalizeForComparison(currentQuestion.options[i]) ==
                    normalizedAns) {
                  answerIndex = i;
                  break;
                }
              }

              // --- Change here: Only add if a valid index is found ---
              if (answerIndex != -1 && answerIndex < answerLetters.length) {
                selectedAnswerText.add("${answerLetters[answerIndex]}. $ans");
              }
              // --- Removed debugPrint and else branch for "error" placeholder ---
            }

            List<String> optionsMapLetters = [
              "A",
              "B",
              "C",
              "D",
              "E",
              "F",
              "G",
              "H"
            ];

            if (currentQuestion.videoExplanationUrl != null) {
              ytCtrl = YoutubePlayerController(
                  initialVideoId: YoutubePlayer.convertUrlToId(
                          currentQuestion.videoExplanationUrl!) ??
                      "");
            }

            return SizedBox(
              height: size.height * 0.7,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    if (currentQuestion.imageUrl != null)
                      ProportionalImage(imageUrl: currentQuestion.imageUrl),
                    QuestionTextContainer(
                      questionNumber: index + 1,
                      question: currentQuestion.questionText,
                      textStyle: textTh.bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                      maxWidth: size.width,
                    ),
                    const SizedBox(height: 12),
                    ...currentQuestion.options.map(
                      (op) {
                        // Removed debugPrint for option/answers here.

                        int opIndex = currentQuestion.options.indexOf(op);
                        String letter = "";
                        if (opIndex != -1 &&
                            opIndex < optionsMapLetters.length) {
                          letter = optionsMapLetters[opIndex];
                        } else {
                          letter = "?"; // Fallback for unexpected index
                        }

                        Color containerColor =
                            Theme.of(context).colorScheme.surface;

                        String normalizedOp = _normalizeForComparison(op);
                        List<String> normalizedCorrectAnswers =
                            currentAnswerHolder.correctAnswers
                                .map((e) => _normalizeForComparison(e))
                                .toList();
                        List<String> normalizedSelectedAnswers =
                            currentAnswerHolder.selectedAnswers
                                .map((e) => _normalizeForComparison(e))
                                .toList();

                        if (normalizedCorrectAnswers.contains(normalizedOp)) {
                          if (normalizedSelectedAnswers
                              .contains(normalizedOp)) {
                            containerColor =
                                Colors.greenAccent; // Correctly selected
                          } else {
                            containerColor = Colors
                                .green; // Correct but not selected (display as correct)
                          }
                        } else {
                          if (normalizedSelectedAnswers
                              .contains(normalizedOp)) {
                            containerColor =
                                Colors.redAccent; // Incorrectly selected
                          }
                        }
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(6),
                          margin: const EdgeInsets.symmetric(vertical: 4),
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
                    ).toList(),
                    const SizedBox(height: 12),
                    if (currentQuestion.explanation != "") ...[
                      ExplanationContainer(
                        explanation: currentQuestion.explanation,
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
                    if (currentQuestion.videoExplanationUrl != null &&
                        currentQuestion.videoExplanationUrl != "")
                      YoutubePlayer(
                        width: size.width,
                        aspectRatio: 16 / 9,
                        bottomActions: [
                          const CurrentPosition(),
                          const ProgressBar(isExpanded: true),
                          FullScreenButton(
                            controller: ytCtrl,
                          ),
                        ],
                        controller: ytCtrl,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.mainBlue,
                        progressColors: ProgressBarColors(
                          playedColor: AppColors.mainBlue,
                          handleColor: AppColors.mainBlue.withOpacity(0.6),
                        ),
                      ),
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
                                // Removed debugPrint
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
                                // Removed debugPrint
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
                                  ? 'Back To Exams'
                                  : 'Next',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
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
    pageViewController.dispose();
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
    ytCtrl.addListener(() {
      // Add logic here if needed
    });
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
