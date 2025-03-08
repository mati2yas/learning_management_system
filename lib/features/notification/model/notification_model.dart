class NotificationData {
  final String title, content;
  NotificationData({
    required this.title,
    required this.content,
  });
}

class NotificationModel {
  int currentPage, totalPages;
  final List<NotificationData> notifDatas;

  NotificationModel({
    required this.notifDatas,
    this.currentPage = 0,
    this.totalPages = 10,
  });
}
