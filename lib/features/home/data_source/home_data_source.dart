import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/model/chapter.dart';
import '../../shared/model/shared_course_model.dart';

class HomeDataSource {
  final Dio _dio;
  HomeDataSource(this._dio);
  List<Course> fetchCourses() {
    return [
      Course(
        title: "Web Design",
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

  Future<List<Course>> getCourses() async {
    final prefs = await SharedPreferences.getInstance();

    List<Course> courses = [];
    final Map<String, dynamic> mapVal = await getUserData();
    print(mapVal);
    try {
      var token = mapVal["token"];
      print("token: $token");
      _dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.get("/courses");

      if (response.statusCode == 200) {
        var data = response.data["data"];

        for (var dataVl in data) {
          print(dataVl);
          Course crs = Course.fromJson(dataVl);
          print(crs.title);

          for (int i = 0; i < 3; i++) {
            courses.add(crs);
          }
        }

        print("courses: \n ${courses.length}");
      }
    } catch (e) {
      rethrow;
    }
    return courses;
  }

  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var userDataString = prefs.getString("userData") ?? "{}";

    userDataString = userDataString.replaceAll('\'', '"');
    userDataString = userDataString.replaceAllMapped(
      RegExp(
          r'(?<=[:\s{,])([a-zA-Z0-9_.@]+|\d[a-zA-Z0-9_.|]+[\d]+)(?=[,\s}])'), // Modified regex
      (match) => '"${match.group(0)}"', // Wrap in double quotes
    );
    prefs.setString("userData", userDataString);
    // Parse the JSON string into a Map
    try {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      return userData;
    } catch (e) {
      print("Error decoding user data: $e");
    }
    return {}; // Return an empty map if no data or error
  }
}
