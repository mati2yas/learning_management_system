import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/constants/fonts.dart';
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
      color: mainBackgroundColor,
      margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: ListTile(
          title: Text(
            quiz.title,
            maxLines: 3,
            style: textTh.labelMedium!.copyWith(
                fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
          ),
          subtitle: Row(
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
                maxLines: 3,
                style: textTh.labelSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          trailing: CustomButton(
            isFilledButton: true,
            buttonWidth: 50,
            buttonHeight: 25,
            buttonWidget: Text("Take",
                style: textTheme.labelMedium!.copyWith(
                  letterSpacing: 0.5,
                  fontFamily: "Inter",
                  color: Colors.white,
                )),
            buttonAction: () async {
              await callback();
            },
          )),
    );
  }
}
