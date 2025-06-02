import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';

import '../../shared/model/shared_course_model.dart';

// final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
//   return HomeDataSource(DioClient.instance);
// });

// class HomeDataSource {
//   final Dio _dio;
//   HomeDataSource(this._dio);

//   Future<List<Course>> getCourses() async {
//     List<Course> courses = [];
//     User? userr;
//     int? statusCode;
//     try {
//       //var user = await SecureStorageService().getUserFromStorage();
//       //userr = user;
//       ////debugPrint("HomePageApi Token: ${user?.token}");

//       await DioClient.setToken();
//       debugPrint(
//           "diotoken in homepage: ${_dio.options.headers["Authorization"]}");

//       var dioTok = (_dio.options.headers["Authorization"] ?? "") as String;
//       dioTok = dioTok.replaceAll("Bearer", "");
//       if (dioTok == "" || dioTok.length < 10) {
//         statusCode = 00;
//         throw Exception("Token not set yet");
//       }

//       _dio.options.headers['Accept'] = 'application/json';

//       // if (["", null].contains(user?.token)) {
//       //   statusCode = 00;
//       //   throw Exception("Token not set yet");
//       // }
//       final response = await _dio.get(
//         AppUrls.homePageCourses,
//       );
//       statusCode = response.statusCode;
//       //debugPrint("in homepage statuscode: ${response.statusCode}");
//       if (response.statusCode == 200) {
//         //dynamic data1 = [];

//         List<dynamic> data1 = response.data["data"];
//         ////debugPrint("${data1.length} values");

//         for (var dataVl in data1) {
//           //print(dataVl);
//           //debugPrint("image url: ${dataVl["thumbnail"] ?? "_"}");
//           Course crs = Course.fromJson(dataVl);
//           //print(crs.title);

//           courses.add(crs);
//         }

//         courses.sort((courseA, courseB) =>
//             courseA.title.toLowerCase().compareTo(courseB.title.toLowerCase()));
//         //debugPrint("courses length: \n ${courses.length}");
//       }
//     } on DioException catch (e) {
//       String errorMsg = e.message ?? "no error message";
//       String errorResMsg = e.response?.statusMessage ?? "no status message";
//       debugPrint(
//           "in homepage exception for token ${(userr?.token ?? "000").substring(0, 3)}: \n error message: $errorMsg, \n errorStatusMessage: $errorResMsg");
//       final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
//       throw Exception(errorMessage);
//     }
//     return courses;
//   }
// }

// Ensure you have your Course model and ApiExceptions setup in your project.
// If Provider is not used, you can remove this line.
final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});

class HomeDataSource {
  final Dio _dio;
  HomeDataSource(this._dio);

  Future<List<Course>> getCourses() async {
    List<Course> courses = [];
    int? statusCode;

    // Retry logic setup for THIS specific call
    const int maxRetries =
        1; // 1 retry attempt after the initial failure (total 2 tries)
    int currentAttempt = 0;

    // Loop for retries
    while (currentAttempt <= maxRetries) {
      try {
        // Ensure token is set for each attempt in case it expires or changes
        await DioClient.setToken();

        // Your existing local token validity check
        var dioTok = (_dio.options.headers["Authorization"] ?? "") as String;
        dioTok = dioTok.replaceAll("Bearer", "");
        if (dioTok == "" || dioTok.length < 10) {
          statusCode = 00; // Indicate a local token error
          // This specific Exception is NOT a DioException, so it won't be caught by _shouldRetry
          // and won't trigger a network retry. This is desired.
          throw Exception("Token not set yet or invalid locally.");
        }

        _dio.options.headers['Accept'] = 'application/json';

        final response = await _dio.get(AppUrls.homePageCourses);
        statusCode = response.statusCode;

        if (kDebugMode) {
          debugPrint("in homepage statuscode: ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          List<dynamic> data1 = response.data["data"];

          for (var dataVl in data1) {
            Course crs = Course.fromJson(dataVl);
            courses.add(crs);
          }

          courses.sort((courseA, courseB) => courseA.title
              .toLowerCase()
              .compareTo(courseB.title.toLowerCase()));

          return courses; // Success! Exit the loop and return the courses.
        } else {
          // If the status code is not 200 but the request completed,
          // re-throw it as a DioException so _shouldRetry can check it
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType
                .badResponse, // Specific type for non-200 responses
            error: "Received status code: ${response.statusCode}",
          );
        }
      } on DioException catch (e) {
        // Check if the error is retryable based on its type
        final bool isRetryable = _shouldRetry(e);

        if (isRetryable && currentAttempt < maxRetries) {
          currentAttempt++;
          if (kDebugMode) {
            debugPrint(
                'Retrying getCourses: ${AppUrls.homePageCourses} (Attempt $currentAttempt)');
          }
          // Add a delay before retrying
          await Future.delayed(
              const Duration(seconds: 2)); // Wait 2 seconds before the next try
        } else {
          // If not retryable, or max retries reached, re-throw the final error
          String errorMessage =
              ApiExceptions.getExceptionMessage(e, e.response?.statusCode);
          if (kDebugMode) {
            debugPrint(
                "Failed to fetch courses after ${currentAttempt + 1} attempts. Error: $errorMessage");
          }
          throw Exception(errorMessage);
        }
      } on Exception catch (e) {
        // This catches your specific "Token not set yet" exception
        // or any other non-DioException. These are generally not retried.
        if (kDebugMode) {
          debugPrint(
              "An unexpected (non-Dio) error occurred in getCourses: $e");
        }
        throw e; // Re-throw the original non-DioException
      }
    }
    // This line should theoretically not be reached if the loop correctly handles
    // success or throws an error after all retries.
    throw Exception(
        "Failed to fetch courses after all attempts (loop exited unexpectedly).");
  }

  // Helper method to determine if a DioException should trigger a retry
  // This is a private method within HomeDataSource
  bool _shouldRetry(DioException err) {
    // Retry on network/connection errors or timeouts
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    // Retry on specific HTTP status codes (e.g., server errors, service unavailable)
    if (err.response?.statusCode != null) {
      if ((err.response!.statusCode ?? 500) >= 500 &&
          (err.response!.statusCode ?? 500) < 600) {
        // It's a 5xx server error, potentially transient
        return true;
      }
    }

    return false;
  }
}
