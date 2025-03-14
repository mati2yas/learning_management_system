import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeHelper {
  static String getThumbnailUrl(String videoLink) {
    final videoId = getVideoId(videoLink);
    return 'https://img.youtube.com/vi/$videoId/0.jpg';
  }

  static String getVideoId(String videoLink) {
    final uri = Uri.parse(videoLink);
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      debugPrint(
          "video url: $videoLink, id: ${YoutubePlayer.convertUrlToId(videoLink) ?? ""}");
      return YoutubePlayer.convertUrlToId(videoLink) ?? '';
    } else {
      return '';
    }
  }
}
