import 'package:dio/dio.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/exams/model/exam_year.dart';

class ExamSubscriptionModel {
  final List<ExamYear> examYears;
  final ExamType examType;
  final SubscriptionType subscriptionType;
  final String screenshotPath;
  final String transactionId;
  final String statusMessage;
  final bool statusSuccess;
  ApiState apiState;

  ExamSubscriptionModel({
    this.examYears = const [],
    this.examType = ExamType.exam,
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
    ExamType? examType,
  }) {
    return ExamSubscriptionModel(
      examYears: newExamYears ?? examYears,
      subscriptionType: newType ?? subscriptionType,
      screenshotPath: newImagePath ?? screenshotPath,
      transactionId: newTransactionId ?? transactionId,
      statusMessage: statusMsg ?? statusMessage,
      apiState: apiState ?? this.apiState,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      examType: examType ?? this.examType,
    );
  }

  Future<FormData> toFormData() async {
    FormData formData = FormData();

    // Convert course IDs to integers before encoding as JSON
    //List<int> courseIds =
    //courses.map((course) => int.parse(course.id)).toList();

    // for (var examYear in examYears) {
    //   int index = examYears.indexOf(examYear);

    //   formData.fields
    //       .add(MapEntry("exams[$index]", examYear.examSheetId.toString()));
    // }
    //debugPrint("in toFormData class, examyears len: ${examYears.length}");
    for (int index = 0; index < examYears.length; index++) {
      formData.fields.add(
          MapEntry("exams[$index]", examYears[index].examSheetId.toString()));
    }
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

    UtilFunctions().printFormData(formData);

    return formData;
  }
}
