import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class Course {
  final String title, image;
  final int topics, saves, likes;
  final double progress;
  final List<Chapter> chapters;
  String? streamOrDepartment;
  final String category;
  bool subscribed;
  bool saved, liked;
  final Map<SubscriptionType, double> price;
  Course({
    required this.title,
    required this.topics,
    required this.saves,
    required this.likes,
    required this.category,
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
    var categ = json["category"]["name"];
    var dep = json["department"];
    return Course(
      title: json["course_name"],
      streamOrDepartment: json["department"]?["department_name"],
      topics: 4,
      saves: 5,
      liked: json["liked"],
      saved: json["saved"],
      likes: 10,
      image: json["thumbnail"],
      category: categ,
      price: {
        SubscriptionType.oneMonth:
            double.tryParse(json["price_one_month"]) ?? 0,
        SubscriptionType.threeMonths:
            double.tryParse(json["price_three_month"]) ?? 0,
        SubscriptionType.sixMonths:
            double.tryParse(json["price_six_month"]) ?? 0,
        SubscriptionType.yearly: double.tryParse(json["price_one_year"]) ?? 0,
      },
      chapters: [],
    );
  }
}
