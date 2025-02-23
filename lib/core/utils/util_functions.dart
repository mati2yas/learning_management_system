import 'dart:ui';

import 'package:lms_system/features/exams/model/exams_model.dart';

class UtilFunctions {
  String getExamStringValue(ExamType type) {
    return switch (type) {
      ExamType.matric => "ESSLCE",
      ExamType.ministry6th => "6th Grade Ministry",
      ExamType.ministry8th => "8th Grade Ministry",
      ExamType.exitexam => "EXIT",
      ExamType.uat => "UAT",
      ExamType.sat => "SAT",
      ExamType.ngat => "NGAT",
    };
  }

  static double getResponsiveChildAspectRatio(Size size) {
    print("width: ${size.width}");
    if (size.width <= 200) return 0.65;
    if (size.width <= 400) return 0.85;

    if (size.width < 500) return 1.0;
    if (size.width < 600) return 1.3;
    if (size.width < 700) return 1.4;
    return 1.7;
  }
}
