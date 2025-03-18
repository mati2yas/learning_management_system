import 'package:lms_system/core/constants/enums.dart';

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
      title: json["type"],
      content: json["message"] ?? "No Message",
    );
  }
}

class NotificationModel {
  int currentPage, totalPages;
  final List<NotificationData> unreadNotifs;
  final List<NotificationData> readNotifs;

  NotificationModel({
    this.unreadNotifs = const [],
    this.readNotifs = const [],
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

    if (notificationType == NotifType.unread) {
      return NotificationModel(
          unreadNotifs: datas,
          currentPage: json['current_page'] ?? 1,
          totalPages: json['last_page'] ?? 10);
    } else {
      return NotificationModel(
          readNotifs: datas,
          currentPage: json['current_page'] ?? 1,
          totalPages: json['last_page'] ?? 10);
    }
  }

  NotificationModel copyWith({
    List<NotificationData>? unreadNotifs,
    List<NotificationData>? readNotifs,
    int? currentPage,
    int? totalPages,
  }) {
    return NotificationModel(
      unreadNotifs: unreadNotifs ?? this.unreadNotifs,
      readNotifs: readNotifs ?? this.readNotifs,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

// class NotificationModel {
//   int currentPage, totalPages;
//   final List<NotificationData> unreadNotifs;
//   final List<NotificationData> readNotifs;

//   NotificationModel({
//     this.unreadNotifs = const [],
//     this.readNotifs = const [],
//     this.currentPage = 0,
//     this.totalPages = 10,
//   });

//   factory NotificationModel.fromJson({
//     required Map<String, dynamic> json,
//     required NotifType notificationType,
//   }) {
//     List<NotificationData> datas = [];
//     for (var entry in json.entries) {
//       debugPrint("${entry.key}: ${entry.value}");
//     }

//     dynamic notifs = json["notifications"];
//     if (notifs is String) {
//       notifs = [];
//     }
//     for (var nData in notifs) {
//       for (var e in nData.entries) {
//         debugPrint("${e.key}: ${e.value}");
//       }
//       debugPrint("nData is a map of ");
//       datas.add(NotificationData.fromJson(nData));
//     }
//     if (notificationType == NotifType.unread) {
//       return NotificationModel(unreadNotifs: datas);
//     } else {
//       return NotificationModel(readNotifs: datas);
//     }
//   }
// }
