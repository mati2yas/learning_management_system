import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';
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
        id: "0",
        title: "Web Design",
        category: "",
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
              Video(url: "What is Web Design?", title: "10:23"),
              Video(url: "Tools for Web Design", title: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", title: "12:34"),
              Video(url: "HTML Tags", title: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        id: "1",
        title: "Marketing",
        category: "",
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
              Video(url: "What is Web Design?", title: "10:23"),
              Video(url: "Tools for Web Design", title: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", title: "12:34"),
              Video(url: "HTML Tags", title: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        id: "2",
        title: "Applied Mathematics",
        category: "",
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
              Video(url: "What is Web Design?", title: "10:23"),
              Video(url: "Tools for Web Design", title: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", title: "12:34"),
              Video(url: "HTML Tags", title: "18:50"),
            ],
          ),
        ],
      ),
      Course(
        id: "3",
        title: "Accounting",
        category: "",
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
              Video(url: "What is Web Design?", title: "10:23"),
              Video(url: "Tools for Web Design", title: "15:45"),
            ],
          ),
          Chapter(
            name: "Chapter 2",
            title: "HTML Basics",
            videos: [
              Video(url: "HTML Structure", title: "12:34"),
              Video(url: "HTML Tags", title: "18:50"),
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
    int? statusCode;
    print(mapVal);
    try {
      var token = mapVal["token"];
      print("token: $token");
      //_dio.options.headers = {"Authorization": "Bearer $token"};
      final response = await _dio.get("/random-courses");
      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        var data = response.data["data"];

        for (var dataVl in data) {
          //print(dataVl);
          Course crs = Course.fromJson(dataVl);
          //print(crs.title);

          courses.add(crs);
        }

        print("courses: \n ${courses.length}");
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
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
    // var mapVal = jsonDecode(userDataString);
    // mapVal["password"] = "12345678";
    // userDataString = jsonEncode(mapVal);
    // print("userDataString: $userDataString");
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
