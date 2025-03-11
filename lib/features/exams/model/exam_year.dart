import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/exams/model/exams_model.dart';

class ExamYear {
  final String title;
  final int id, examSheetId, questionCount;
  final int duration;
  final List<Question> questions; // For non-matric exams
  final List<ExamGrade> grades; // For matric exams
  bool subscribed, pending;

  final Map<SubscriptionType, double> price;
  Map<SubscriptionType, double?> onSalePrices;

  ExamYear({
    required this.id,
    required this.examSheetId,
    required this.title,
    required this.duration,
    this.questions = const [],
    this.subscribed = false,
    this.pending = false,
    required this.price,
    this.onSalePrices = const {},
    this.questionCount = 0,
    this.grades = const [],
  });
  factory ExamYear.fromJson(
    Map<String, dynamic> json,
  ) {
    Map<SubscriptionType, double?> onSalePrices = {
      SubscriptionType.oneMonth: null,
      SubscriptionType.threeMonths: null,
      SubscriptionType.sixMonths: null,
      SubscriptionType.yearly: null,
    };
    double getDoubleVal(dynamic p1m) {
      double doubleVal = 0.00;
      debugPrint("the number $p1m");
      // if (p1m == null) {
      //   debugPrint("is null");
      //   doubleVal = 0.00;
      // } else if (p1m is int) {
      //   debugPrint("is int");
      //   doubleVal = (p1m as num).toDouble();
      // } else if (p1m is double) {
      //   debugPrint("is double");
      //   doubleVal = p1m;
      // }
      if (p1m == null) {
        return 0.00;
      } else if (p1m is String) {
        return double.tryParse(p1m) ?? 0.0;
      } else {
        return (p1m as num).toDouble();
      }
    }

    var p1m = json["price_one_month"];
    var p3m = json["price_three_month"];
    var p6m = json["price_six_month"];
    var p1y = json["price_one_year"];
    double priceOneMonth = getDoubleVal(p1m);
    double priceThreeMonth = getDoubleVal(p3m);
    double priceSixMonth = getDoubleVal(p6m);
    double priceOneYear = getDoubleVal(p1y);
    debugPrint(
        "one month: $priceOneMonth, 3 month: $priceThreeMonth, six: $priceSixMonth, a year: $priceOneYear");

    if (json["on_sale_one_month"] != null) {
      onSalePrices[SubscriptionType.oneMonth] =
          double.tryParse(json["on_sale_one_month"]);
    }
    if (json["on_sale_three_month"] != null) {
      onSalePrices[SubscriptionType.threeMonths] =
          double.tryParse(json["on_sale_three_month"]);
    }
    if (json["on_sale_six_month"] != null) {
      onSalePrices[SubscriptionType.sixMonths] =
          double.tryParse(json["on_sale_six_month"]);
    }

    return ExamYear(
      id: json["id"] ?? 0,
      title: json["year_name"] ?? "year name",
      examSheetId: json["exam_sheet_id"] ?? 0,
      questionCount: json['exam_questions_count'] ?? 0,
      duration: json["duration"] ?? 20,
      price: {
        SubscriptionType.oneMonth: priceOneMonth,
        SubscriptionType.threeMonths: priceThreeMonth,
        SubscriptionType.sixMonths: priceSixMonth,
        SubscriptionType.yearly: priceOneYear,
      },
      subscribed: json["is_paid"],
      pending: json["pending"] ?? false,
    );
  }

  factory ExamYear.initial() {
    return ExamYear(
      id: -1,
      examSheetId: -1,
      duration: 0,
      title: "",
      price: {},
    );
  }

  double getPriceBySubscriptionType(SubscriptionType subscriptionType) {
    double priceValue =
        onSalePrices[subscriptionType] ?? price[subscriptionType]!;
    return priceValue;
  }
}
