import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/forgot_password/model/forgot_password_model.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:path_provider/path_provider.dart';

final forgotPasswordDataSourceProvider =
    Provider<ForgotPasswordDataSource>((ref) {
  return ForgotPasswordDataSource(
    DioClient.instance,
    SecureStorageService(),
  );
});

class ForgotPasswordDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  ForgotPasswordDataSource(this._dio, this._storageService);
  Future<Response> changePassword({
    required String password,
    required String email,
    required String token,
  }) async {
    int? statusCode;

    final Response res = Response(
      requestOptions: RequestOptions(),
    );
    try {
      final response = await _dio.post(AppUrls.changePassword, data: {
        "email": email,
        "pin": token,
        "password": password,
        "password_confirmation": password,
      });
      statusCode = response.statusCode;
      debugPrint("url: ${AppUrls.baseUrl}/${AppUrls.changePassword}");
      debugPrint("{email: $email, password: $password, token: $token}");
      debugPrint("status code: ${response.statusCode}");

      debugPrint("response data:");
      for (var entry in response.data.entries ?? {}.entries) {
        if (entry.key == "user") {
          for (var usrData in entry.value.entries ?? {}.entries) {
            debugPrint("${usrData.key}: ${usrData.value}");
          }
        }
      }

      if (response.statusCode == 200) {
        String savePath = "";
        final token = response.data["token"];
        debugPrint("response data:");
        for (var entry in response.data["data"]?.entries ?? {}.entries) {
          if (entry.key == "user") {
            for (var usrData in entry.value.entries ?? {}.values) {
              debugPrint("${usrData.key}: ${usrData.value}");
            }
          } else {
            debugPrint("${entry.key}: ${entry.value}");
          }
        }
        String? avatar = response.data["data"]["user"]["avatar"];
        if (avatar != null) {
          avatar.replaceAll("\\", "");
          avatar = "${AppUrls.backendStorage}/$avatar";
          debugPrint(avatar);

          final directory = await getApplicationDocumentsDirectory();
          final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

          savePath = '${directory.path}/$imageName';

          await _dio.download(avatar, savePath);
        }

        final user = User(
          id: response.data["data"]["user"]["id"],
          name: response.data["data"]["user"]["name"],
          email: email,
          password: password,
          bio: response.data["data"]["user"]["bio"] ?? "",
          image: savePath,
          token: response.data["token"] ?? "no token",
        );
        debugPrint("token: $token");

        // Save the user data to the database
        await _storageService.saveUserToStorage(user);
        return response;
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return res;
  }

  Future<ForgotPasswordModel> forgotPassword({required String email}) async {
    int? statusCode;
    ForgotPasswordModel forgotPasswordModel = ForgotPasswordModel(email: email);
    try {
      debugPrint("forgot password, is email null?");
      final response = await _dio.post(
        AppUrls.forgotPassword,
        data: {
          "email": email,
        },
      );
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        forgotPasswordModel = ForgotPasswordModel(
          email: email,
          apiMessage: response.data["message"] ?? "No or Missing Message",
          apiSuccess: response.data["success"] ?? "Success",
        );
        //await _storageService.saveForgotPassData(forgotPassData);
      } else if (response.statusCode == 403) {
        var msg = response.data["message"] ?? "Error Message?";
        throw Exception(msg);
      } else {
        throw Exception('Failed to reset password: Unknown error');
      }
    } on DioException catch (e) {
      debugPrint("dio exception at forgot password");
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return forgotPasswordModel;
  }
}
