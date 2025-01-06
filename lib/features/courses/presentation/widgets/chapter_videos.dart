import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/courses/provider/chapter_videos_index.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/colors.dart';

class ChapterVideosWidget extends ConsumerStatefulWidget {
  final Chapter chapter;
  const ChapterVideosWidget({
    super.key,
    required this.chapter,
  });

  @override
  ConsumerState<ChapterVideosWidget> createState() =>
      _ChapterVideosWidgetState();
}

class _ChapterVideosWidgetState extends ConsumerState<ChapterVideosWidget> {
  YoutubePlayerController ytCtrl = YoutubePlayerController(initialVideoId: "");
  int seconds = 0;
  int videoIndex = 0;
  late CurrentPlayingVideoTracker videoTracker;
  @override
  Widget build(BuildContext context) {
    print("3. then build method is called");
    List<Video> nonPlayingVids = widget.chapter.videos;
    nonPlayingVids.removeAt(videoIndex);
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
                    widget.chapter.name,
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
                for (var vid in nonPlayingVids)
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
                        Stack(
                          children: [
                            Image.network(
                              'https://img.youtube.com/vi/${vid.title}/0.jpg',
                            ),
                            Center(
                              child: IconButton(
                                onPressed: () {
                                  int curr = widget.chapter.videos.indexOf(vid);
                                  videoTracker.setCurrentIndex(curr);
                                },
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.transparent,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.chapter.name,
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

  @override
  void initState() {
    super.initState();

    print("1. initstate starts");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("2: ytcontrol inits");
      videoTracker = ref.watch(currentPlayingVideoTracker.notifier);
      videoIndex = ref.watch(currentPlayingVideoTracker);
      ytCtrl = YoutubePlayerController(
        initialVideoId: widget.chapter.videos[0].title,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
        ),
      );
      dynamic val;
      ytCtrl.addListener(() {
        Duration dur = ytCtrl.value.position;
        if (seconds < dur.inSeconds) {
          seconds = dur.inSeconds;
        }
        print("$seconds out of ${ytCtrl.value.metaData.duration}");
      });
    });
  }
}
