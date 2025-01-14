import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';

class Course {
  final String title, image;
  final int topics, saves, likes;
  final double progress;
  final List<Chapter> chapters;
  String? streamOrDepartment;
  bool subscribed;
  bool saved, liked;
  final Map<SubscriptionType, double> price;
  Course({
    required this.title,
    required this.topics,
    required this.saves,
    required this.likes,
    required this.image,
    this.progress = 0.0,
    this.subscribed = false,
    this.saved = false,
    this.liked = false,
    required this.price,
    required this.chapters,
    this.streamOrDepartment,
  });
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json["course_name"],
      topics: 4,
      saves: 5,
      likes: 10,
      image: json["thumbnail"],
      price: {
        SubscriptionType.oneMonth: 100,
        SubscriptionType.threeMonths: 288,
        SubscriptionType.sixMonths: 560,
        SubscriptionType.yearly: 1000,
      },
      chapters: [], 
    );
  }
}
