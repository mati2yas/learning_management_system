import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../quiz/model/quiz_model.dart';

class ChapterQuizTile extends ConsumerWidget {
  final Quiz quiz;
  final Function callback;
  const ChapterQuizTile({
    super.key,
    required this.quiz,
    required this.callback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: SizedBox(
        height: 70,
        child: Row(
          children: <Widget>[
            // ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       topLeft: Radius.circular(10.0),
            //       bottomLeft: Radius.circular(10.0),
            //     ),
            //     child: SizedBox(
            //       width: 70,
            //       height: 70,
            //       child: Image.asset(
            //         "assets/images/applied_math.png",
            //         fit: BoxFit.cover,
            //       ),
            //     )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 10.0, 15, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: textTh.labelMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: size.width * 0.1,
                            child: const LinearProgressIndicator(
                              value: 0.8,
                              color: AppColors.mainBlue,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/topics.svg",
                                width: 12,
                                height: 12,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.mainBlue,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${quiz.numberOfQuestions ?? 0} questions",
                                style: textTh.labelMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.mainBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fixedSize: const Size(130, 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          onPressed: () async {
                            await callback();
                          },
                          child: const Text(
                            "Take",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
