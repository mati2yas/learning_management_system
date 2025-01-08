import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';
import 'package:lms_system/requests/presentation/screens/requests_screen.dart';

class RequestsDataSource {
  List<Course> fetchAddedCourses() {
    return [
      Course(
        title: "Web Desien",
        desc: "web design",
        topics: 21,
        saves: 7,
        likes: 12,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        liked: false,
        image: "web_design.png",
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(title: "What is Web Design?", duration: "10:23"),
              Video(title: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(title: "HTML Structure", duration: "12:34"),
              Video(title: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Marketing",
        desc: "web design",
        topics: 21,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        saves: 7,
        likes: 7,
        liked: true,
        image: "marketing_course.png",
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(title: "What is Web Design?", duration: "10:23"),
              Video(title: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(title: "HTML Structure", duration: "12:34"),
              Video(title: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
    ];
  }
}
