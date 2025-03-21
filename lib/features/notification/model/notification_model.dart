import 'package:lms_system/core/constants/enums.dart';

class NotificationData {
  final title, content;
  final int id;
  NotificationData({
    required this.id,
    required this.title,
    required this.content,
  });
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json["id"] ?? 0,
      title: json["type"] ?? "",
      content: json["message"] ?? "No Message",
    );
  }
}

class NotificationModel {
  int currentPage, totalPages;
  final List<NotificationData> notifs;

  NotificationModel({
    this.notifs = const [],
    this.currentPage = 1,
    this.totalPages = 10,
  });

  factory NotificationModel.fromJson(
      {required Map<String, dynamic> json,
      required NotifType notificationType}) {
    List<NotificationData> datas = [];

    List<dynamic> notifs = json["data"];

    // if (notifs is String) {
    //   notifs = [];
    // }

    for (var nData in notifs) {
      datas.add(NotificationData.fromJson(nData));
    }

    return NotificationModel(
      notifs: datas,
      currentPage: json['current_page'] ?? 1,
      totalPages: json['last_page'] ?? 10,
    );
  }

  NotificationModel copyWith({
    List<NotificationData>? notifs,
    int? currentPage,
    int? totalPages,
  }) {
    return NotificationModel(
      notifs: notifs ?? this.notifs,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
