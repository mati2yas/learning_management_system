import 'package:dio/dio.dart';
import 'package:lms_system/features/courses/data_source/course_detail_data_source.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';

import '../../shared/model/chapter.dart';
import '../../shared/model/shared_course_model.dart';
import '../model/categories_sub_categories.dart';

class CourseDataSource {
  final Dio _dio;
  CourseDataSource(this._dio);

  List<CourseCategory> fetchCourseFromGrade(
    CategoryType categoryType,
    Grade grade,
  ) {
    return categoriesData.where((catData) {
      return catData.grades.contains(grade) &&
          catData.categoryType == categoryType;
    }).toList();
  }

  List<Course> fetchCourses() {
    return [
      Course(
        title: "Web Design",
        topics: 21,
        saves: 9,
        image: "web_design.png",
        saved: true,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        likes: 12,
        liked: false,
        subscribed: true,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Accounting",
        topics: 21,
        saves: 7,
        image: "accounting_course.png",
        saved: false,
        subscribed: true,
        likes: 12,
        liked: false,
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
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Marketing",
        topics: 21,
        saves: 12,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        image: "marketing_course.png",
        saved: true,
        likes: 12,
        liked: false,
        subscribed: false,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Applied Mathematics",
        topics: 21,
        likes: 12,
        liked: false,
        saves: 7,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        image: "applied_math.png",
        saved: true,
        subscribed: true,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Accounting",
        topics: 21,
        saves: 7,
        image: "accounting_course.png",
        saved: false,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        subscribed: true,
        likes: 12,
        liked: false,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Marketing",
        topics: 21,
        saves: 12,
        image: "marketing_course.png",
        saved: true,
        likes: 12,
        liked: false,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        subscribed: false,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Applied Mathematics",
        topics: 21,
        likes: 12,
        liked: false,
        saves: 4,
        image: "applied_math.png",
        saved: true,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        subscribed: true,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Accounting",
        topics: 21,
        saves: 7,
        likes: 12,
        liked: false,
        image: "accounting_course.png",
        saved: false,
        price: {
          SubscriptionType.oneMonth: 72.0,
          SubscriptionType.threeMonths: 216.0,
          SubscriptionType.sixMonths: 432.0,
          SubscriptionType.yearly: 864.0,
        },
        subscribed: true,
        chapters: [
          Chapter(
            name: "Chapter 2",
            title: "Introduction to Web Design",
            videos: [
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Applied Mathematics",
        topics: 21,
        likes: 12,
        liked: false,
        saves: 7,
        image: "applied_math.png",
        saved: true,
        subscribed: true,
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
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        title: "Accounting",
        topics: 21,
        saves: 7,
        image: "accounting_course.png",
        saved: false,
        subscribed: true,
        likes: 12,
        liked: false,
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
              Video(url: "What is Web Design?", duration: "10:23"),
              Video(url: "Tools for Web Design", duration: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", duration: "12:34"),
              Video(url: "HTML Tags", duration: "18:50"),
            ],
          ),
        ],
      ),
    ];
  }
}
