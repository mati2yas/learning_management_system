import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/features/courses/provider/chapter_videos_index.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        return isLandscape
            ? SafeArea(
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      Center(
                        child: YoutubePlayer(
                          width: constraints.maxWidth * 0.9,
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
                      ),
                      Positioned(
                        child: Container(
                          height: 40,
                          width: constraints.maxWidth,
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                          ),
                          child: Row(
                            spacing: 12,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.video.title,
                                style: textTh.titleMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                appBar: CommonAppBar(titleText: widget.video.title),
                body: Padding(
                  padding: const EdgeInsets.all(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: constraints.maxHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            YoutubePlayer(
                              width: size.width * 0.9,
                              aspectRatio: 16 / 9,
                              bottomActions: const [
                                CurrentPosition(),
                                ProgressBar(isExpanded: true),
                                CurrentPosition(),
                                FullScreenButton(),
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
      },
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
    ytCtrl.addListener(() {});
    print("1. initstate starts");
  }
}
