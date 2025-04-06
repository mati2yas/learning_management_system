import 'package:flutter/material.dart';
import 'package:lms_system/core/constants/app_strings.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class Course {
  final String title, image;
  final String id;
  final int topics, saves, likes;
  final double progress;
  final List<Chapter> chapters;
  String? stream;
  String? department;
  String? category;
  String? grade;
  String? batch;
  bool subscribed;
  bool saved, liked;
  final Map<SubscriptionType, double> price;
  Map<SubscriptionType, double?> onSalePrices;

  Course({
    required this.title,
    required this.id,
    required this.topics,
    required this.saves,
    required this.likes,
    this.category,
    required this.image,
    this.progress = 0.0,
    this.subscribed = false,
    this.saved = false,
    this.liked = false,
    required this.chapters,
    required this.price,
    this.onSalePrices = const {},
    this.stream,
    this.department,
    this.batch,
    this.grade,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var categ = json["category"]?["name"];

    var dep = json["department"];

    Map<SubscriptionType, double?> onSalePrices = {
      SubscriptionType.oneMonth: null,
      SubscriptionType.threeMonths: null,
      SubscriptionType.sixMonths: null,
      SubscriptionType.yearly: null,
    };

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
    if (json["on_sale_one_year"] != null) {
      onSalePrices[SubscriptionType.yearly] =
          double.tryParse(json["on_sale_one_year"]);
    }

    var chapters = json["chapters"] ?? <dynamic>[];

    String? grade = json["grade"]?["grade_name"];
    String? stream = json["grade"]?["stream"];

    debugPrint("in course model: grade: $grade, stream: $stream");
    if (grade == AppStrings.grade11 || grade == AppStrings.grade12) {
      //debugPrint("grade 11/12, stream is: $stream");
      stream ??= AppStrings.commonStream;
      //debugPrint("grade 11/12, after setting stream: $stream");
    }

    return Course(
      id: json["id"].toString(),
      title: json["course_name"],
      department: json["department"]?["department_name"],
      //stream: json["grade"]?["stream"],
      stream: stream,
      batch: json["batch"]?["batch_name"],
      grade: grade,
      topics: json["chapter_count"] ?? 0,
      likes: json["likes_count"] ?? 0,
      saves: json["saves_count"] ?? 0,
      liked: json["is_liked"] ?? false,
      saved: json["is_saved"] ?? false,
      subscribed: json["is_paid"] ?? false,
      image: json["thumbnail"],
      category: categ,
      price: {
        SubscriptionType.oneMonth:
            double.tryParse(json["price_one_month"] ?? 0) ?? 0,
        SubscriptionType.threeMonths:
            double.tryParse(json["price_three_month"] ?? 0) ?? 0,
        SubscriptionType.sixMonths:
            double.tryParse(json["price_six_month"] ?? 0) ?? 0,
        SubscriptionType.yearly:
            double.tryParse(json["price_one_year"] ?? 0) ?? 0,
      },
      onSalePrices: onSalePrices,
      chapters: [],
    );
  }

  factory Course.fromJsonLocal(Map<String, dynamic> json) {
    return Course(
      title: json['title'],
      id: json['id'],
      topics: json['topics'],
      saves: json['saves'],
      likes: json['likes'],
      image: json['image'],
      price: Map<SubscriptionType, double>.from(json['price']),
      onSalePrices: Map<SubscriptionType, double?>.from(json['priceOnsale']),
      chapters: [],
    );
  }

  double getPriceBySubscriptionType(SubscriptionType subscriptionType) {
    double priceValue =
        onSalePrices[subscriptionType] ?? price[subscriptionType]!;
    return priceValue;
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      'title': title,
      'id': id,
      'topics': topics,
      'saves': saves,
      'likes': likes,
      'image': image,
      'price': price.map((key, value) => MapEntry(key.name, value)),
      'priceOnsale':
          onSalePrices.map((key, value) => MapEntry(key.name, value)),
    };
  }

  static Course initial() {
    return Course(
      title: "",
      id: "",
      topics: 0,
      saves: 0,
      likes: 0,
      image: "",
      price: {},
      chapters: [],
    );
  }
}
