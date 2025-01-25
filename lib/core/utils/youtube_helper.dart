import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeHelper {
  static String getVideoId(String videoLink) {
  
  final uri = Uri.parse(videoLink);
  if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
    return YoutubePlayer.convertUrlToId(videoLink) ?? '';
  } else {
    return '';
  }
}

static String getThumbnailUrl(String videoLink) {
  final videoId = getVideoId(videoLink);
  return 'https://img.youtube.com/vi/$videoId/0.jpg';
}

}