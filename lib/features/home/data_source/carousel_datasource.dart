import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';

final carouselDatasourceProvider = Provider<CarouselDatasource>(
  (ref) => CarouselDatasource(DioClient.instance),
);

class CarouselContent {
  final int id;
  final String tag;
  final String imageUrl;
  final int order;

  CarouselContent({
    required this.id,
    required this.tag,
    required this.imageUrl,
    required this.order,
  });

  factory CarouselContent.fromJson(Map<String, dynamic> json) {
    debugPrint("carousel content:");
    for (var entry in json.entries) {
      debugPrint("${entry.key}: ${entry.value}");
    }
    return CarouselContent(
      id: json["id"] ?? 0,
      tag: json["tag"] ?? "Welcome to Excelet Academy",
      imageUrl: json["image_url"] ?? "",
      order: json["order"] ?? 0,
    );
  }
}

class CarouselDatasource {
  final Dio _dio;
  CarouselDatasource(this._dio);
  Future<List<CarouselContent>> getCarouselContents() async {
    List<CarouselContent> contents = [];
    int? statusCode;

    try {
      await DioClient.setToken();
      final response = await _dio.get(AppUrls.carouselContents);
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        List<dynamic> data = response.data["data"];

        for (var value in data) {
          CarouselContent content = CarouselContent.fromJson(value);
          contents.add(content);
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return contents;
  }
}
