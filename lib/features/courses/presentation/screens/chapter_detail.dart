import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/shared_course/model/chapter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChapterDetailPage extends StatefulWidget {
  final Chapter chapter;
  const ChapterDetailPage({
    super.key,
    required this.chapter,
  });

  @override
  State<ChapterDetailPage> createState() => _ChapterDetailPageState();
}

class _ChapterDetailPageState extends State<ChapterDetailPage> {
  late YoutubePlayerController ytCtrl;
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    Chapter chapter = widget.chapter;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${chapter.name} -- ${chapter.title}",
          style: textTh.labelLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.4,
            width: size.width * 0.8,
            child: YoutubePlayer(
              controller: ytCtrl,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.mainBlue,
              progressColors: ProgressBarColors(
                playedColor: AppColors.mainBlue,
                handleColor: AppColors.mainBlue.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ytCtrl = YoutubePlayerController(
      initialVideoId: widget.chapter.videos[0].title,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }
}
