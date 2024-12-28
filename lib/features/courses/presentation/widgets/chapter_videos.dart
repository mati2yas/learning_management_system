import 'package:flutter/material.dart';
import 'package:lms_system/features/shared_course/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';

class ChapterVideosWidget extends StatelessWidget {
  final Chapter chapter;
  final YoutubePlayerController ytCtrl;
  const ChapterVideosWidget({
    super.key,
    required this.chapter,
    required this.ytCtrl,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: size.height * 0.3,
            width: size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColors.darkerGrey,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                YoutubePlayer(
                  controller: ytCtrl,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: AppColors.mainBlue,
                  progressColors: ProgressBarColors(
                    playedColor: AppColors.mainBlue,
                    handleColor: AppColors.mainBlue.withOpacity(0.6),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    chapter.name,
                    style: textTh.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Next Video",
              style: textTh.bodyLarge,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: size.height * 0.5,
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 15,
              ),
              children: [
                Container(
                  width: size.width * .6,
                  height: size.width * .6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.darkerGrey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/${chapter.videos[0].title}/0.jpg',
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name,
                          style: textTh.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: size.width * .6,
                  height: size.width * .6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.darkerGrey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/${chapter.videos[0].title}/0.jpg',
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name,
                          style: textTh.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: size.width * .6,
                  height: size.width * .6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.darkerGrey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/${chapter.videos[0].title}/0.jpg',
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name,
                          style: textTh.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: size.width * .6,
                  height: size.width * .6,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.darkerGrey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/${chapter.videos[0].title}/0.jpg',
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chapter.name,
                          style: textTh.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
