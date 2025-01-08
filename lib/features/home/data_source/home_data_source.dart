import 'package:lms_system/requests/presentation/screens/requests_screen.dart';

import '../../shared/model/chapter.dart';
import '../../shared/model/shared_course_model.dart';

class HomeDataSource {
  List<Course> fetchCourses() {
    return [
      Course(
        title: "Web Design",
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
      Course(
        title: "Applied Mathematics",
        desc: "web design",
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        topics: 21,
        saves: 7,
        likes: 21,
        liked: true,
        image: "applied_math.png",
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
        title: "Accounting",
        desc: "web design",
        topics: 21,
        saves: 7,
        likes: 9,
        liked: false,
        image: "accounting_course.png",
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
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
