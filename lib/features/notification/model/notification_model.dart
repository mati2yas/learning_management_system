import 'package:flutter/material.dart';

class NotificationData {
  final String id, title, content;
  NotificationData({
    required this.id,
    required this.title,
    required this.content,
  });
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json["id"],
      title: "",
      content: json["data"]["message"] ?? "No Message",
    );
  }
}

class NotificationModel {
  int currentPage, totalPages;
  final List<NotificationData> notifDatas;

  NotificationModel({
    required this.notifDatas,
    this.currentPage = 0,
    this.totalPages = 10,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    List<NotificationData> datas = [];
    for (var entry in json.entries) {
      debugPrint("${entry.key}: ${entry.value}");
    }

    dynamic notifs = json["notifications"];
    if (notifs is String) {
      notifs = [];
    }
    for (var nData in notifs) {
      for (var e in nData.entries) {
        debugPrint("${e.key}: ${e.value}");
      }
      debugPrint("nData is a map of ");
      datas.add(NotificationData.fromJson(nData));
    }
    return NotificationModel(notifDatas: datas);
  }
}
