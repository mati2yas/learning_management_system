import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

import '../../../../core/constants/colors.dart';

class ChapterQuizTile extends StatelessWidget {
  final Quiz quiz;
  const ChapterQuizTile({
    super.key,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
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
                            width: size.width * 0.8,
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
                                "100 questions",
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
                              borderRadius: BorderRadius.circular(20),
                            ),
                            fixedSize: const Size(130, 25),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                          onPressed: () {},
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
