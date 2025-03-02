import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/features/courses/provider/chapter_videos_index.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../core/constants/colors.dart';

class ChapterVideoWidget extends ConsumerStatefulWidget {
  final Video video;
  const ChapterVideoWidget({
    super.key,
    required this.video,
  });

  @override
  ConsumerState<ChapterVideoWidget> createState() =>
      _ChapterVideosWidgetState();
}

class _ChapterVideosWidgetState extends ConsumerState<ChapterVideoWidget> {
  YoutubePlayerController ytCtrl = YoutubePlayerController(initialVideoId: "");
  int seconds = 0;
  int videoIndex = 0;
  late CurrentPlayingVideoTracker videoTracker;
  @override
  Widget build(BuildContext context) {
    print("3. then build method is called");
    var textTh = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppBar(titleText: "Watch Video"),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              YoutubePlayer(
                width: size.width * 0.8,
                aspectRatio: 16 / 9,
                bottomActions: const [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                  CurrentPosition(),
                  //PlayPauseButton(),
                  FullScreenButton(),
                ],
                controller: ytCtrl,
                showVideoProgressIndicator: true,
                progressIndicatorColor: AppColors.mainBlue,
                progressColors: ProgressBarColors(
                  playedColor: AppColors.mainBlue,
                  handleColor: AppColors.mainBlue.withValues(alpha: 0.6),
                ),
              ),
              Text(
                widget.video.title,
                style: textTh.bodyMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
    url = widget.video.url;
    print("2: ytcontrol inits");
    ytCtrl = YoutubePlayerController(
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
      ),
      initialVideoId: YoutubePlayer.convertUrlToId(url) ?? "",
    );
    dynamic val;
    ytCtrl.addListener(() {
      // Duration dur = ytCtrl.value.position;
      // if (seconds < dur.inSeconds) {
      //   seconds = dur.inSeconds;
      // }
      print("$seconds out of ${ytCtrl.value.metaData.duration}");
    });
    print("1. initstate starts");
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }
}
