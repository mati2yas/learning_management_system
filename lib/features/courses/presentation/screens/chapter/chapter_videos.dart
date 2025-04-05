// import 'package:flutter/material.dart';
// import 'package:lms_system/features/shared/model/chapter.dart';
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';

// class ChapterVideoWidget extends StatefulWidget {
//   final Video video;
//   const ChapterVideoWidget({super.key, required this.video});

//   @override
//   State<ChapterVideoWidget> createState() => _ChapterVideosWidgetState();
// }

// class Controls extends StatelessWidget {
//   ///
//   const Controls({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         spacing: 10,
//         children: [
//           const MetaDataSection(),
//           PlayPauseButtonBar(),
//           const VideoPositionSeeker(),
//           const PlayerStateSection(),
//         ],
//       ),
//     );
//   }
// }

// class MetaDataSection extends StatelessWidget {
//   const MetaDataSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return YoutubeValueBuilder(
//       buildWhen: (o, n) {
//         return o.metaData != n.metaData ||
//             o.playbackQuality != n.playbackQuality;
//       },
//       builder: (context, value) {
//         return Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _Text('Title', value.metaData.title),
//             _Text(
//               'Playback Quality',
//               value.playbackQuality ?? '',
//             ),
//             Row(
//               children: [
//                 const _Text(
//                   'Speed',
//                   '',
//                 ),
//                 YoutubeValueBuilder(
//                   builder: (context, value) {
//                     return DropdownButton(
//                       value: value.playbackRate,
//                       isDense: true,
//                       underline: const SizedBox(),
//                       items: PlaybackRate.all
//                           .map(
//                             (rate) => DropdownMenuItem(
//                               value: rate,
//                               child: Text(
//                                 '${rate}x',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w300,
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (double? newValue) {
//                         if (newValue != null) {
//                           context.ytController.setPlaybackRate(newValue);
//                           context.ytController.setSize(480, 600);
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class PlayerStateSection extends StatelessWidget {
//   const PlayerStateSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return YoutubeValueBuilder(
//       builder: (context, value) {
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 800),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             color: _getStateColor(value.playerState),
//           ),
//           width: double.infinity,
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             value.playerState.toString(),
//             style: const TextStyle(
//               fontWeight: FontWeight.w300,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         );
//       },
//     );
//   }

//   Color _getStateColor(PlayerState state) {
//     switch (state) {
//       case PlayerState.unknown:
//         return Colors.grey[700]!;
//       case PlayerState.unStarted:
//         return Colors.pink;
//       case PlayerState.ended:
//         return Colors.red;
//       case PlayerState.playing:
//         return Colors.blueAccent;
//       case PlayerState.paused:
//         return Colors.orange;
//       case PlayerState.buffering:
//         return Colors.yellow;
//       case PlayerState.cued:
//         return Colors.blue[900]!;
//       default:
//         return Colors.blue;
//     }
//   }
// }

// class PlayPauseButtonBar extends StatelessWidget {
//   final ValueNotifier<bool> _isMuted = ValueNotifier(false);

//   PlayPauseButtonBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         IconButton(
//           icon: const Icon(Icons.skip_previous),
//           onPressed: context.ytController.previousVideo,
//         ),
//         YoutubeValueBuilder(
//           builder: (context, value) {
//             return IconButton(
//               icon: Icon(
//                 value.playerState == PlayerState.playing
//                     ? Icons.pause
//                     : Icons.play_arrow,
//               ),
//               onPressed: () {
//                 value.playerState == PlayerState.playing
//                     ? context.ytController.pauseVideo()
//                     : context.ytController.playVideo();
//               },
//             );
//           },
//         ),
//         ValueListenableBuilder<bool>(
//           valueListenable: _isMuted,
//           builder: (context, isMuted, _) {
//             return IconButton(
//               icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
//               onPressed: () {
//                 _isMuted.value = !isMuted;
//                 isMuted
//                     ? context.ytController.unMute()
//                     : context.ytController.mute();
//               },
//             );
//           },
//         ),
//         IconButton(
//           icon: const Icon(Icons.skip_next),
//           onPressed: context.ytController.nextVideo,
//         ),
//       ],
//     );
//   }
// }

// class VideoPositionIndicator extends StatelessWidget {
//   ///
//   const VideoPositionIndicator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = context.ytController;

//     return StreamBuilder<YoutubeVideoState>(
//       stream: controller.videoStateStream,
//       initialData: const YoutubeVideoState(),
//       builder: (context, snapshot) {
//         final position = snapshot.data?.position.inMilliseconds ?? 0;
//         final duration = controller.metadata.duration.inMilliseconds;

//         return LinearProgressIndicator(
//           value: duration == 0 ? 0 : position / duration,
//           minHeight: 1,
//         );
//       },
//     );
//   }
// }

// ///
// class VideoPositionSeeker extends StatelessWidget {
//   ///
//   const VideoPositionSeeker({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var value = 0.0;

//     return Row(
//       children: [
//         const Text(
//           'Seek',
//           style: TextStyle(fontWeight: FontWeight.w300),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: StreamBuilder<YoutubeVideoState>(
//             stream: context.ytController.videoStateStream,
//             initialData: const YoutubeVideoState(),
//             builder: (context, snapshot) {
//               final position = snapshot.data?.position.inSeconds ?? 0;
//               final duration = context.ytController.metadata.duration.inSeconds;

//               value = position == 0 || duration == 0 ? 0 : position / duration;

//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return Slider(
//                     value: value,
//                     onChanged: (positionFraction) {
//                       value = positionFraction;
//                       setState(() {});

//                       context.ytController.seekTo(
//                         seconds: (value * duration).toDouble(),
//                         allowSeekAhead: true,
//                       );
//                     },
//                     min: 0,
//                     max: 1,
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _Button extends StatelessWidget {
//   final VoidCallback? onTap;

//   final String action;
//   const _Button({required this.onTap, required this.action});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onTap == null
//           ? null
//           : () {
//               onTap?.call();
//               FocusScope.of(context).unfocus();
//             },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Text(action),
//       ),
//     );
//   }
// }

// class _ChapterVideosWidgetState extends State<ChapterVideoWidget> {
//   late YoutubePlayerController ytCtrl;
//   bool isFullScreen = false;

//   @override
//   Widget build(BuildContext context) {
//     return YoutubePlayerScaffold(
//       controller: ytCtrl,
//       builder: (context, player) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Play Video'),
//           ),
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               return ListView(
//                 children: [
//                   player,
//                   const VideoPositionIndicator(),
//                   const Controls(),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     ytCtrl.close();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     String videoId =
//         YoutubePlayerController.convertUrlToId(widget.video.url) ?? "";
//     ytCtrl = YoutubePlayerController.fromVideoId(
//       videoId: videoId,
//       params: const YoutubePlayerParams(
//         showControls: true,
//         showFullscreenButton: true,
//         enableCaption: true,
//         loop: false,
//       ),
//     );
//     ytCtrl.setFullScreenListener(
//       (isFullScreen) {
//         debugPrint('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
//       },
//     );
//   }
// }

// class _PlaylistTypeDropDown extends StatefulWidget {
//   final ValueChanged<ListType?> onChanged;

//   const _PlaylistTypeDropDown({required this.onChanged});

//   @override
//   _PlaylistTypeDropDownState createState() => _PlaylistTypeDropDownState();
// }

// class _PlaylistTypeDropDownState extends State<_PlaylistTypeDropDown> {
//   ListType? _playlistType;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<ListType>(
//       decoration: InputDecoration(
//         border: InputBorder.none,
//         fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
//         filled: true,
//       ),
//       isExpanded: true,
//       value: _playlistType,
//       items: [
//         DropdownMenuItem(
//           child: Text(
//             'Select playlist type',
//             style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                   color: Theme.of(context).colorScheme.onSurfaceVariant,
//                   fontWeight: FontWeight.w300,
//                 ),
//           ),
//         ),
//         ...ListType.values.map(
//           (type) => DropdownMenuItem(value: type, child: Text(type.value)),
//         ),
//       ],
//       onChanged: (value) {
//         _playlistType = value;
//         setState(() {});
//         widget.onChanged(value);
//       },
//     );
//   }
// }

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
  bool isPressed = false;
  double videoWidthFactor = 0.8;

  @override
  Widget build(BuildContext context) {
    debugPrint("3. then build method is called");

    var textTh = Theme.of(context).textTheme;

    var size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;

        return isLandscape
            ? SafeArea(
                child: Scaffold(
                  body: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        Center(
                          child: YoutubePlayer(
                            width: constraints.maxWidth * videoWidthFactor,
                            aspectRatio: 16 / 9,
                            topActions: const [],
                            bottomActions: [
                              const ProgressBar(isExpanded: false),
                              const MetaData(),
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
                          left: hidingContainerDistance(constraints.maxWidth),
                          top: 0,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                            ),
                            child: IconButton(
                              onPressed: () {
                                ytCtrl.reset();
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: hidingContainerDistance(constraints.maxWidth),
                          top: 0,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/ngat.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  double hidingContainerDistance(double maxWidth) {
    var videoWidth = maxWidth * videoWidthFactor;
    var leftRightDistance = maxWidth - videoWidth;
    return leftRightDistance / 2;
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
    )..addListener(() {});

    dynamic val;

    ytCtrl.addListener(() {});

    print("1. initstate starts");
  }
}

class _Text extends StatelessWidget {
  final String title;
  final String value;

  const _Text(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$title : ',
        style: Theme.of(context).textTheme.labelLarge,
        children: [
          TextSpan(
            text: value,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
