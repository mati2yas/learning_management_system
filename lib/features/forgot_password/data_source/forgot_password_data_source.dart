import 'package:dio/dio.dart';
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
  Future<void> changePassword({
    required String password,
    required String email,
    required String token,
  }) async {
    int? statusCode;

    try {
      final forgotpassData = await _storageService.getForgotPassData();
      if (forgotpassData == null) {
        return;
      }

      String email = forgotpassData.email;
      String resetToken = forgotpassData.token;

      final response = await _dio.post(AppUrls.changePassword, data: {
        "email": email,
        "password": password,
        "password_confirmation": password,
        "token": resetToken,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        String savePath = "";
        final token = response.data["token"];
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
          token: token,
        );
        debugPrint("token: $token");

        // Save the user data to the database
        await _storageService.saveUserToStorage(user);
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }

  Future<void> forgotPassword({required String email}) async {
    int? statusCode;
    try {
      final response = await _dio.post(
        AppUrls.forgotPassword,
        data: {
          "email": email,
        },
      );
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        String changePassToken = response.data["token"] ?? "no-token";
        final forgotPassData = ForgotPasswordModel(
          email: email,
          token: changePassToken,
        );
        await _storageService.saveForgotPassData(forgotPassData);
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to reset password: Unknown error');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }

  resetPassword() {}
}
