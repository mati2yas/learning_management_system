import 'package:dio/dio.dart';
import 'package:lms_system/features/requests/presentation/screens/requests_screen.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class SavedDataSource {
  final Dio _dio;
  SavedDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    int? statusCode;
    //   try {

    //     final response = await _dio.get("/random-courses");
    //     statusCode = response.statusCode;
    //     if (response.statusCode == 200) {
    //       var data = response.data["data"];

    //       for (var dataVl in data) {
    //         Course crs = Course.fromJson(dataVl);
    //         courses.add(crs);
    //       }
    //       courses = courses.take(5).toList();

    //       print("courses: \n ${courses.length}");
    //     }
    //   } on DioException catch (e) {
    //     final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
    //     throw Exception(errorMessage);
    //   }
    //   return courses;
    // }
    //Future<ApiResponse> bookmarkCourse(Course course) async {}
    await Future.delayed(const Duration(seconds: 4));
    courses = [
      Course(
        title: "Mathematics",
        id: "10",
        topics: 12,
        saves: 12,
        likes: 11,
        image: "",
        price: {
          SubscriptionType.oneMonth: 121.2,
          SubscriptionType.sixMonths: 121.2,
        },
        chapters: [],
      ),
      Course(
        title: "Physics",
        id: "10",
        topics: 12,
        saves: 12,
        likes: 11,
        image: "",
        price: {
          SubscriptionType.oneMonth: 121.2,
          SubscriptionType.sixMonths: 121.2,
        },
        chapters: [],
      ),
      Course(
        title: "Chemistry",
        id: "10",
        topics: 12,
        saves: 12,
        likes: 11,
        image: "",
        price: {
          SubscriptionType.oneMonth: 121.2,
          SubscriptionType.sixMonths: 121.2,
        },
        chapters: [],
      ),
      Course(
        title: "Mathematics",
        id: "10",
        topics: 12,
        saves: 12,
        likes: 11,
        image: "",
        price: {
          SubscriptionType.oneMonth: 121.2,
          SubscriptionType.sixMonths: 121.2,
        },
        chapters: [],
      ),
    ];
    return courses;
  }
}
