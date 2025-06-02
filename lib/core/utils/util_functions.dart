import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';

class UtilFunctions {
  // String determineProperImageUrl(String firstUrl) {
  //   String result = "";
  //   if (firstUrl.startsWith("/id")) {
  //     result = "https://picsum.photos/$firstUrl.jpg";
  //   } else if (firstUrl.startsWith("https://")) {
  //     result = "${AppUrls.backendStorage}/question_images";
  //   }
  //   return result;
  // }

  String getExamStringValue(ExamType type) {
    return switch (type) {
      ExamType.matric => "ESSLCE",
      ExamType.ministry6th => "6th Grade Ministry",
      ExamType.ministry8th => "8th Grade Ministry",
      ExamType.exitexam => "EXIT",
      ExamType.exam => "EXAM",
      ExamType.uat => "UAT",
      ExamType.sat => "SAT",
      ExamType.ngat => "NGAT",
    };
  }

  void printFormData(FormData formData) {
    final formDataMap =
        formData.fields.map((field) => '${field.key}: ${field.value}');
    final fileDataMap =
        formData.files.map((file) => '${file.key}: ${file.value.filename}');
    final allData = [...formDataMap, ...fileDataMap];
    debugPrint(allData.join('\n'));
  }

  void printMapData(Map<String, dynamic> formData) {
    final formDataMap =
        formData.entries.map((entry) => '${entry.key}: ${entry.value}');
    final allData = [...formDataMap];
    debugPrint(allData.join('\n'));
  }

  static SnackBar buildErrorSnackbar({
    required String errorMessage,
    dynamic exception,
  }) {
    String exceptionStripped = stripExceptionLabel(exception) ?? "";
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red.withAlpha(100),
      elevation: 4,
      content: Text(
        //stripExceptionLabel(error.toString()),
        errorMessage,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  static SnackBar buildInfoSnackbar({required String message}) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.blueGrey.withAlpha(240),
      elevation: 4,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  static double getResponsiveChildAspectRatio(Size size) {
    // print("width: ${size.width}");
    if (size.width <= 200) return 0.65;
    if (size.width <= 400) return 0.85;

    if (size.width < 500) return 1.0;
    if (size.width < 600) return 1.3;
    if (size.width < 700) return 1.4;
    return 1.7;
  }

  static String? stripExceptionLabel(dynamic exc) {
    if (exc == null) {
      return null;
    }
    return exc.toString().replaceAll("Exception:", "");
  }
}
