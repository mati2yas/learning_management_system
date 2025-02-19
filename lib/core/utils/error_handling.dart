import 'package:dio/dio.dart';

class ApiExceptions {
  static String getExceptionMessage(Exception exc, int? statusCode) {
    if (exc is! DioException) {
      if (exc.toString().contains("No internet connection") ||
          exc.toString().contains("Connection Timeout")) {
        return "No connection. Check your internet.";
      }
      return "Unknown Error Occurred";
    }
    switch (exc.type) {
      case DioExceptionType.badResponse:
        if (statusCode == 500) {
          return "The error is on our side. We're working on it.";
        } else if (statusCode == 419) {
          return "Access. Please log in again.";
        } else if (statusCode == 401) {
          return "Unauthorized. No valid credentials or permissions.";
        } else if (statusCode == 404) {
          return "Resource not found.";
        } else {
          // Handle other status codes generically
          return "Error $statusCode: ${exc.response?.statusMessage ?? "Unknown error"}";
        }

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection Timeout. Please check your internet connection.";

      case DioExceptionType.cancel:
        return "Request was cancelled.";

      case DioExceptionType.connectionError:
        return "Connection Error. Unable to connect to the server.";

      case DioExceptionType.unknown:
      default:
        return "An unexpected error occurred: ${exc.message}";
    }
  }
}
