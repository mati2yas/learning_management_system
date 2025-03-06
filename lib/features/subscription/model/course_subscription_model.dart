import 'package:dio/dio.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CourseSubscriptionModel {
  final List<Course> courses;
  final SubscriptionType subscriptionType;
  final String screenshotPath;
  final String transactionId;
  final String statusMessage;
  final bool statusSuccess;
  ApiState apiState;

  CourseSubscriptionModel({
    this.courses = const [],
    this.subscriptionType = SubscriptionType.oneMonth,
    this.screenshotPath = "",
    this.transactionId = "",
    this.statusMessage = "",
    this.statusSuccess = false,
    this.apiState = ApiState.idle,
  });
  CourseSubscriptionModel copyWith({
    List<Course>? newCourses,
    SubscriptionType? newType,
    String? newImagePath,
    String? newTransactionId,
    String? statusMsg,
    ApiState? apiState,
    bool? statusSuccess,
  }) {
    return CourseSubscriptionModel(
      courses: newCourses ?? courses,
      subscriptionType: newType ?? subscriptionType,
      screenshotPath: newImagePath ?? screenshotPath,
      transactionId: newTransactionId ?? transactionId,
      statusMessage: statusMsg ?? statusMessage,
      apiState: apiState ?? this.apiState,
      statusSuccess: statusSuccess ?? this.statusSuccess,
    );
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData();

    // Convert course IDs to integers before encoding as JSON
    //List<int> courseIds =
    //courses.map((course) => int.parse(course.id)).toList();

    for (var course in courses) {
      int index = courses.indexOf(course);
      formData.fields.add(MapEntry("courses[$index]", course.id));
    }
    // ✅ Append courses as a single field with an array value
    //formData.fields.add(MapEntry("courses", jsonEncode(courseIds)));

    // ✅ Append other fields
    formData.fields.add(MapEntry("subscription_type", subscriptionType.name));
    formData.fields.add(MapEntry("transaction_id", transactionId));

    // ✅ Append image as file
    formData.files.add(
      MapEntry(
        "screenshot",
        await MultipartFile.fromFile(
          screenshotPath,
          filename: "screenshot.jpg",
        ),
      ),
    );

    return formData;
  }
}
