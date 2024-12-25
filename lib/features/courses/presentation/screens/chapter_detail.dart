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
        centerTitle: true,
        elevation: 5,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            width: size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 187, 191, 255),
                    foregroundColor: Colors.black,
                    elevation: 3,
                  ),
                  onPressed: () {},
                  child: const Text("Video"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainBlue,
                    foregroundColor: Colors.white,
                    elevation: 3,
                  ),
                  onPressed: () {},
                  child: const Text("Document"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainBlue,
                    foregroundColor: Colors.white,
                    elevation: 3,
                  ),
                  onPressed: () {},
                  child: const Text("Quizzes"),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
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
