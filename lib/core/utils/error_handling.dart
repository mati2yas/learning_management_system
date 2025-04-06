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

    final response = exc.response?.data;

    //Handle Validation Errors (e.g., "The email has already been taken.")
    if (response is Map && response.containsKey("errors")) {
      final errors = response["errors"];
      if (errors is Map && errors.isNotEmpty) {
        final firstKey = errors.keys.first; // Get the first error field
        final errorMessages = errors[firstKey]; // Get error messages list
        if (errorMessages is List && errorMessages.isNotEmpty) {
          return errorMessages.first; // Return the first error message
        }
      }
    }

    switch (exc.type) {
      case DioExceptionType.badResponse:
        if (statusCode == 500) {
          return "The error is on our side. We're working on it.";
        } else if (statusCode == 419) {
          return "Access expired. Please log in again.";
        } else if (statusCode == 401) {
          return "Unauthorized. invalid credentials or permissions:";
        } else if (statusCode == 404) {
          return "Resource not found.";
        } else if (response is Map && response.containsKey("message")) {
          return response["message"]; // Handle generic error messages from API
        } else {
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
        return "Something went wrong";
    }
  }
}
