import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/youtube_helper.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class VideoTile extends StatelessWidget {
  final Video video;
  final GestureTapCallback onTap;

  const VideoTile({
    super.key,
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: mainBackgroundColor,
        margin: const EdgeInsets.only(top: 3, left: 3, right: 2.6),
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.5)),
        ),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5.5),
                    bottomLeft: Radius.circular(5.5),
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      YoutubeHelper.getThumbnailUrl(video.url),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 15, 8.0),
                child: Text(
                  video.title,
                  maxLines: 4,
                  style: textTh.labelMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
