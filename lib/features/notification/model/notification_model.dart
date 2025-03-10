class NotificationData {
  final String title, content;
  NotificationData({
    required this.title,
    required this.content,
  });
  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      title: "",
      content: json["message"] ?? "No Message",
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
    List<dynamic> notifs = json["notifications"];
    for (var n in notifs) {
      var nData = n["data"] ?? {};
      datas.add(NotificationData.fromJson(nData));
    }
    return NotificationModel(notifDatas: datas);
  }
}
