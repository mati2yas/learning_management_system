import 'package:flutter/material.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/explanation_container.dart';
import 'package:lms_system/core/common_widgets/question_text_container.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExamSolutionsScreen extends StatefulWidget {
  final List<Question> questions;
  const ExamSolutionsScreen({
    super.key,
    required this.questions,
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
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageViewController,
              itemCount: widget.questions.length,
              itemBuilder: (_, index) {
                final currentQuestion = widget.questions[index];
                String multipleQuestionsIndicator = "";
                if (currentQuestion.answers.length > 1) {
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
                List<String> answerText = [];

                int answerIndex = 0;

                for (var ans in currentQuestion.answers) {
                  answerIndex = currentQuestion.options
                      .indexOf(currentQuestion.answers[0]);

                  answerText.add("${answerLetters[answerIndex]}. $ans");
                }

                if (currentQuestion.videoExplanationUrl != null) {
                  ytCtrl = YoutubePlayerController(
                      initialVideoId: currentQuestion.videoExplanationUrl!);
                }

                return SizedBox(
                  height: size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        spacing: 12,
                        children: [
                          QuestionTextContainer(
                            question: currentQuestion.questionText,
                            textStyle: textTh.bodyMedium!,
                            maxWidth: size.width * 0.75,
                          ),
                          Text(
                            "Answer(s):",
                            style: textTh.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...answerText.map((ans) => Text(ans)),
                          ExplanationContainer(
                            explanation: currentQuestion.explanation,
                            textStyle: textTh.bodySmall!,
                            maxWidth: size.width * 0.75,
                          ),
                          if (currentQuestion.imageExplanationUrl != null)
                            SizedBox(
                              width: size.width * 0.8,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  height: 80,
                                  width: double.infinity,
                                  "${currentQuestion.imageExplanationUrl}.jpg", //?? "",
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
                                      Object error, StackTrace? stackTrace) {
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
                          if (currentQuestion.videoExplanationUrl != null)
                            YoutubePlayer(
                              width: size.width * 0.75,
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
                          const SizedBox(height: 50),
                        ],
                      ),
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
                      if (questionsIndex < (widget.questions.length - 1)) {
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
                          ? 'Back To Exams'
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
