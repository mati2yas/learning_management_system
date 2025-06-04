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

// class ExamSolutionsScreen extends StatefulWidget {
//   final List<Question> questions;
//   final List<AnswersHolder> answerHolders;
//   const ExamSolutionsScreen({
//     super.key,
//     required this.questions,
//     required this.answerHolders,
//   });

//   @override
//   State<ExamSolutionsScreen> createState() => _ExamSolutionsScreenState();
// }

// class _ExamSolutionsScreenState extends State<ExamSolutionsScreen> {
//   YoutubePlayerController ytCtrl = YoutubePlayerController(initialVideoId: "");
//   PageController pageViewController = PageController();
//   int questionsIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.sizeOf(context);
//     var textTh = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: CommonAppBar(titleText: "Exam Solutions"),
//       backgroundColor: mainBackgroundColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: size.height,
//               width: size.width,
//               child: PageView.builder(
//                 scrollDirection: Axis.horizontal,
//                 controller: pageViewController,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: widget.answerHolders.length,
//                 itemBuilder: (_, index) {
//                   final currentAnswerHolder = widget.answerHolders[index];
//                   final currentQuestion = widget.questions.where((question) {
//                     return question.answers ==
//                             currentAnswerHolder.correctAnswers &&
//                         question.id == currentAnswerHolder.questionId;
//                   }).first;

//                   //widget.questions[index];

//                   if (currentQuestion.videoExplanationUrl != null) {
//                     ytCtrl = YoutubePlayerController(
//                         initialVideoId: currentQuestion.videoExplanationUrl!);
//                   }
//                   String multipleQuestionsIndicator = "";
//                   if (currentAnswerHolder.correctAnswers.length > 1) {
//                     multipleQuestionsIndicator = "(Select all that apply.)";
//                   }
//                   List<String> answerLetters = [
//                     "A",
//                     "B",
//                     "C",
//                     "D",
//                     "E",
//                     "F",
//                     "G"
//                   ];
//                   List<String> selectedAnswerText = [];
//                   List<String> correctAnswerText = [];

//                   int answerIndex = 0;
//                   for (var ans in currentAnswerHolder.correctAnswers) {
//                     answerIndex = currentQuestion.options.indexOf(ans);
//                     correctAnswerText
//                         .add("${answerLetters[answerIndex]}. $ans");
//                   }

//                   for (var ans in currentAnswerHolder.selectedAnswers) {
//                     answerIndex = currentQuestion.options.indexOf(ans);
//                     selectedAnswerText
//                         .add("${answerLetters[answerIndex]}. $ans");
//                   }

//                   if (currentQuestion.videoExplanationUrl != null) {
//                     debugPrint(
//                         "video url: ${currentQuestion.videoExplanationUrl}");
//                     ytCtrl = YoutubePlayerController(
//                         initialVideoId: YoutubePlayer.convertUrlToId(
//                                 currentQuestion.videoExplanationUrl!) ??
//                             "");
//                   }

//                   return SizedBox(
//                     height: size.height * 0.7,
//                     child: SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: Column(
//                           children: [
//                             if (currentQuestion.imageUrl != null)
//                               ProportionalImage(
//                                   imageUrl: currentQuestion.imageUrl),
//                             QuestionTextContainer(
//                               questionNumber: index + 1,
//                               question: currentQuestion.questionText,
//                               textStyle: textTh.bodyLarge!
//                                   .copyWith(fontFamily: "Roboto"),
//                               maxWidth: size.width,
//                             ),
//                             Gap(),
//                             ...currentQuestion.options.map(
//                               (option) {
//                                 debugPrint(
//                                     "option: $option, answers: [ ${correctAnswerText.join(",")} ]");
//                                 String letter = [
//                                   "A",
//                                   "B",
//                                   "C",
//                                   "D",
//                                   "E",
//                                   "F",
//                                   "G",
//                                   "H",
//                                 ][currentQuestion.options.indexOf(option)];
//                                 Color containerColor = mainBackgroundColor;

//                                 Widget? trailingIcon;
//                                 if (currentAnswerHolder.correctAnswers
//                                     .contains(option)) {
//                                   if (currentAnswerHolder.selectedAnswers
//                                       .contains(option)) {
//                                     containerColor = correctAnswerColor;
//                                     trailingIcon = Center(
//                                       child: Icon(Icons.check,
//                                           size: 30, color: Colors.black),
//                                     );
//                                   }
//                                 } else {
//                                   if (currentAnswerHolder.selectedAnswers
//                                       .contains(option)) {
//                                     containerColor = wrongAnswerColor;
//                                     trailingIcon =
//                                         Icon(Icons.close, color: Colors.red);
//                                   }
//                                 }
//                                 return Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 32, vertical: 4),
//                                   decoration: BoxDecoration(
//                                     color: containerColor,
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           "$letter. $option",
//                                           style:
//                                               textTheme.titleMedium!.copyWith(
//                                             letterSpacing: 0.5,
//                                             // fontFamily: "Inter",
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                       if (trailingIcon != null) trailingIcon,
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                             ExpansionTile(
//                               tilePadding: EdgeInsets.symmetric(horizontal: 3),
//                               title: Text(
//                                 "Explanation",
//                                 style: textTheme.titleMedium!.copyWith(
//                                     letterSpacing: 0.5,
//                                     fontFamily: "Inter",
//                                     color: AppColors.mainBlue2,
//                                     overflow: TextOverflow.ellipsis),
//                               ),
//                               collapsedShape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(0),
//                                 side: BorderSide(
//                                     color: Colors
//                                         .transparent), // 🔥 Removes collapsed border
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                                 side: BorderSide(
//                                     color: AppColors
//                                         .mainBlue2), // 🔥 Removes expanded border
//                               ),
//                               children: [
//                                 const SizedBox(height: 12),
//                                 if (currentQuestion.explanation != "") ...[
//                                   ExplanationContainer(
//                                     explanation: currentQuestion.explanation,
//                                     textStyle: textTh.bodyMedium!,
//                                     maxWidth: size.width,
//                                   ),
//                                   const SizedBox(height: 12),
//                                 ],
//                                 if (currentQuestion.imageExplanationUrl !=
//                                     null) ...[
//                                   ProportionalImage(
//                                       imageUrl:
//                                           currentQuestion.imageExplanationUrl),
//                                   const SizedBox(height: 12),
//                                 ],
//                                 if (currentQuestion.videoExplanationUrl !=
//                                         null &&
//                                     currentQuestion.videoExplanationUrl != "")
//                                   YoutubePlayer(
//                                     width: size.width,
//                                     aspectRatio: 16 / 9,
//                                     bottomActions: [
//                                       const CurrentPosition(),
//                                       const ProgressBar(isExpanded: true),
//                                       const CurrentPosition(),
//                                       FullScreenButton(
//                                         controller: ytCtrl,
//                                       ),
//                                     ],
//                                     controller: ytCtrl,
//                                     showVideoProgressIndicator: true,
//                                     progressIndicatorColor: AppColors.mainBlue,
//                                     progressColors: ProgressBarColors(
//                                       playedColor: AppColors.mainBlue,
//                                       handleColor: AppColors.mainBlue
//                                           .withValues(alpha: 0.6),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: size.width,
//                               height: 50,
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   DialogListItemNavigator(
//                                     pageViewController: pageViewController,
//                                     itemsCount: widget.answerHolders.length,
//                                   ),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.white,
//                                       elevation: 4,
//                                     ),
//                                     onPressed: () {
//                                       if (questionsIndex > 0) {
//                                         setState(() {
//                                           questionsIndex--;
//                                         });
//                                         debugPrint(
//                                             "current question index: $questionsIndex, questions length: ${widget.questions.length}");
//                                         pageViewController.previousPage(
//                                           duration:
//                                               const Duration(milliseconds: 700),
//                                           curve: Curves.decelerate,
//                                         );
//                                       }
//                                     },
//                                     child: const Text(
//                                       "Previous",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.mainBlue,
//                                       elevation: 4,
//                                     ),
//                                     onPressed: () {
//                                       if (questionsIndex <
//                                           (widget.questions.length - 1)) {
//                                         setState(() {
//                                           questionsIndex++;
//                                         });
//                                         debugPrint(
//                                             "current question index: $questionsIndex, questions length: ${widget.questions.length}");
//                                         pageViewController.nextPage(
//                                           duration:
//                                               const Duration(milliseconds: 700),
//                                           curve: Curves.decelerate,
//                                         );
//                                       } else if (questionsIndex ==
//                                           widget.questions.length - 1) {
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: Text(
//                                       questionsIndex ==
//                                               (widget.questions.length - 1)
//                                           ? 'Back To Exams'
//                                           : 'Next',
//                                       style:
//                                           const TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 120),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     ytCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     String url;
//     url = "";
//     ytCtrl = YoutubePlayerController(
//       flags: const YoutubePlayerFlags(
//         autoPlay: false,
//         mute: false,
//         showLiveFullscreenButton: false,
//       ),
//       initialVideoId: YoutubePlayer.convertUrlToId(url) ?? "",
//     );
//     ytCtrl.addListener(() {});
//   }

//   Future<double?> _getImageAspectRatio(String url) async {
//     final image = Image.network(url);
//     final completer = Completer<ImageInfo>();
//     image.image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((ImageInfo info, _) {
//         completer.complete(info);
//       }),
//     );

//     final info = await completer.future;
//     final width = info.image.width;
//     final height = info.image.height;

//     return width / height;
//   }
// }
// Placeholder for missing constants/colors if not in AppColors
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
  // Initialize with a default controller, will be updated per question
  late YoutubePlayerController ytCtrl;
  PageController pageViewController = PageController();
  int questionsIndex = 0; // Tracks the current question index for navigation buttons

  @override
  void initState() {
    super.initState();
    // Initialize ytCtrl in initState. Its initialVideoId can be empty or a placeholder.
    // It will be updated dynamically in the PageView.builder.
    ytCtrl = YoutubePlayerController(
      initialVideoId: '', // Will be updated dynamically
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
      ),
    );
    // You can add a listener here if you need to react to player state changes globally
    // ytCtrl.addListener(() {
    //   if (kDebugMode) {
    //     print('Player state: ${ytCtrl.value.playerState}');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var textTh = Theme.of(context).textTheme; // Correctly get TextTheme from context

    return Scaffold(
      appBar: CommonAppBar(titleText: "Exam Solutions"),
      backgroundColor: mainBackgroundColor,
      body: Column( // Use Column instead of SingleChildScrollView directly here
        children: [
          Expanded( // Use Expanded to give PageView available height
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: pageViewController,
              physics: const NeverScrollableScrollPhysics(), // Prevent manual swiping
              itemCount: widget.answerHolders.length,
              onPageChanged: (index) {
                // Update questionsIndex when page changes (e.g., via buttons)
                setState(() {
                  questionsIndex = index;
                  // Ensure YouTube player is disposed/reset when changing questions
                  // and a new one is initialized if the new question has a video.
                  // This is better done in the PageView's item builder when the current question is determined.
                });
              },
              itemBuilder: (_, index) {
                // Ensure questionsIndex is updated for button logic
                // It's already handled by onPageChanged.

                final currentAnswerHolder = widget.answerHolders[index];

                // Find the corresponding question from the questions list
                final currentQuestion = widget.questions.firstWhere(
                  (question) =>
                      question.answers.toString() == currentAnswerHolder.correctAnswers.toString() &&
                      question.id == currentAnswerHolder.questionId,
                  // Provide an orElse callback for robustness if a question isn't found
                  orElse: () => Question(
                    id: currentAnswerHolder.questionId,
                    sequenceOrder: 1,
                    questionText: "Question not found.",
                    options: [],
                    answers: [],
                    imageUrl: null,
                    explanation: "This question could not be loaded.",
                    imageExplanationUrl: null,
                    videoExplanationUrl: null,
                  ),
                );

                // Re-initialize YoutubePlayerController if video explanation URL changes
                // This is crucial to prevent multiple controllers or unhandled controllers
                if (currentQuestion.videoExplanationUrl != null && currentQuestion.videoExplanationUrl!.isNotEmpty) {
                   ytCtrl.load(YoutubePlayer.convertUrlToId(currentQuestion.videoExplanationUrl!) ?? "");
                   
                } else {
                  // If no video, load an empty video or pause/stop the existing one
                  ytCtrl.cue(''); // Cue an empty video to stop/reset the player
                }


                // --- START: Re-integrated Answer Normalization Logic ---
                String multipleQuestionsIndicator = "";
                if (currentAnswerHolder.correctAnswers.length > 1) {
                  multipleQuestionsIndicator = "(Select all that apply.)";
                }
                List<String> answerLetters = [
                  "A", "B", "C", "D", "E", "F", "G", "H" // Added H just in case
                ];
                List<String> selectedAnswerText = [];
                List<String> correctAnswerText = [];

                // Populate correctAnswerText
                for (var ans in currentAnswerHolder.correctAnswers) {
                  int answerIndex = currentQuestion.options.indexOf(ans);
                  if (answerIndex != -1 && answerIndex < answerLetters.length) {
                    correctAnswerText.add("${answerLetters[answerIndex]}. $ans");
                  }
                }

                // Populate selectedAnswerText
                for (var ans in currentAnswerHolder.selectedAnswers) {
                  int answerIndex = currentQuestion.options.indexOf(ans);
                  if (answerIndex != -1 && answerIndex < answerLetters.length) {
                    selectedAnswerText.add("${answerLetters[answerIndex]}. $ans");
                  }
                }

                

                return SingleChildScrollView( // Each page needs its own scroll
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
                      children: [
                        if (currentQuestion.imageUrl != null)
                          ProportionalImage(imageUrl: currentQuestion.imageUrl),
                        QuestionTextContainer(
                          questionNumber: index + 1,
                          question: currentQuestion.questionText + " " + multipleQuestionsIndicator, // Show indicator
                          textStyle: textTh.bodyLarge!.copyWith(fontFamily: "Roboto"),
                          maxWidth: size.width,
                        ),
                        Gap(height: 16), // A bit more gap
                        ...currentQuestion.options.map(
                          (option) {
                            // Safely get the letter for the option
                            int optionIndex = currentQuestion.options.indexOf(option);
                            String letter = (optionIndex != -1 && optionIndex < answerLetters.length)
                                ? answerLetters[optionIndex]
                                : ''; // Fallback for invalid index

                            Color containerColor = mainBackgroundColor;
                            Widget? trailingIcon;

                            bool isCorrectAnswer = currentAnswerHolder.correctAnswers.contains(option);
                            bool isSelectedAnswer = currentAnswerHolder.selectedAnswers.contains(option);

                            if (isCorrectAnswer) {
                               trailingIcon = const Center(
                                 child: Icon(Icons.check, size: 30, color: Colors.black),
                               );
                            } else if (!isCorrectAnswer && isSelectedAnswer) {
                               // This option is wrong, but the user selected it
                               containerColor = wrongAnswerColor;
                               trailingIcon = const Icon(Icons.close, color: Colors.red);
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4), // Add vertical padding between options
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12), // Adjusted padding
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(8), // Slightly more rounded
                                  border: Border.all(
                                    color: Colors.grey.shade300, // Add a subtle border
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "$letter. $option",
                                        style: textTh.titleMedium!.copyWith( // Use textTh
                                          letterSpacing: 0.5,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (trailingIcon != null) trailingIcon,
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(), // Add .toList() here
                        Gap(height: 20), // Add a gap before explanation

                        ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 3),
                          title: Text(
                            "Explanation",
                            style: textTh.titleMedium!.copyWith( // Use textTh
                                letterSpacing: 0.5,
                                fontFamily: "Inter",
                                color: AppColors.mainBlue2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(color: AppColors.mainBlue2),
                          ),
                          children: [
                            const SizedBox(height: 12),
                            if (currentQuestion.explanation != null && currentQuestion.explanation!.isNotEmpty) ...[
                              ExplanationContainer(
                                explanation: currentQuestion.explanation!, // Added null check
                                textStyle: textTh.bodyMedium!,
                                maxWidth: size.width,
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (currentQuestion.imageExplanationUrl != null && currentQuestion.imageExplanationUrl!.isNotEmpty) ...[
                              ProportionalImage(imageUrl: currentQuestion.imageExplanationUrl!), // Added null check
                              const SizedBox(height: 12),
                            ],
                            if (currentQuestion.videoExplanationUrl != null && currentQuestion.videoExplanationUrl!.isNotEmpty)
                              YoutubePlayer(
                                width: size.width,
                                aspectRatio: 16 / 9,
                                bottomActions: [
                                  const CurrentPosition(),
                                  const ProgressBar(isExpanded: true),
                                  // Removed duplicate CurrentPosition
                                  FullScreenButton(
                                    controller: ytCtrl,
                                  ),
                                ],
                                controller: ytCtrl,
                                showVideoProgressIndicator: true,
                                progressIndicatorColor: AppColors.mainBlue,
                                progressColors: ProgressBarColors(
                                  playedColor: AppColors.mainBlue,
                                  handleColor: AppColors.mainBlue.withOpacity(0.6), // Use withOpacity
                                ),
                              ),
                          ],
                        ),
                        Gap(height: 20), // Gap before navigation buttons
                        SizedBox(
                          width: size.width,
                          height: 50, // Fixed height for button row
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    pageViewController.previousPage(
                                      duration: const Duration(milliseconds: 300), // Shorter duration
                                      curve: Curves.easeOut, // Smoother curve
                                    );
                                    // setState is handled by onPageChanged for `questionsIndex`
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
                                  if (questionsIndex < (widget.answerHolders.length - 1)) {
                                    pageViewController.nextPage(
                                      duration: const Duration(milliseconds: 300), // Shorter duration
                                      curve: Curves.easeOut, // Smoother curve
                                    );
                                    // setState is handled by onPageChanged for `questionsIndex`
                                  } else if (questionsIndex == widget.answerHolders.length - 1) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  questionsIndex == (widget.answerHolders.length - 1)
                                      ? 'Back To Exams'
                                      : 'Next',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 120), // Sufficient bottom padding
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ytCtrl.dispose();
    pageViewController.dispose(); // Dispose the PageController too
    super.dispose();
  }

  // This method is fine, but not directly used in the build method.
  // It's a utility for aspect ratio, keep it as is.
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