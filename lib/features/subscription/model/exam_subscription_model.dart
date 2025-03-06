import 'package:dio/dio.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';

class ExamSubscriptionModel {
  final List<ExamYear> examYears;
  final SubscriptionType subscriptionType;
  final String screenshotPath;
  final String transactionId;
  final String statusMessage;
  final bool statusSuccess;
  ApiState apiState;

  ExamSubscriptionModel({
    this.examYears = const [],
    this.subscriptionType = SubscriptionType.oneMonth,
    this.screenshotPath = "",
    this.transactionId = "",
    this.statusMessage = "",
    this.statusSuccess = false,
    this.apiState = ApiState.idle,
  });
  ExamSubscriptionModel copyWith({
    List<ExamYear>? newExamYears,
    SubscriptionType? newType,
    String? newImagePath,
    String? newTransactionId,
    String? statusMsg,
    ApiState? apiState,
    bool? statusSuccess,
  }) {
    return ExamSubscriptionModel(
      examYears: newExamYears ?? examYears,
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

    for (var examYear in examYears) {
      int index = examYears.indexOf(examYear);
      formData.fields.add(MapEntry("courses[$index]", examYear.id.toString()));
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
