import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:path_provider/path_provider.dart';

final loginDataSourceProvider = Provider<LoginDataSource>((ref) {
  return LoginDataSource(DioClient.instance, SecureStorageService());
});

class LoginDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  LoginDataSource(this._dio, this._storageService);

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    int? statusCode;
    try {
      final response = await _dio.post(AppUrls.login, data: {
        'email': email,
        'password': password,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        if (response.data["is_verified"] == false) {
          throw Exception("Email not verified");
        }

        String savePath = "";
        final token = response.data["token"];
        debugPrint("login token: $token");
        String? avatar = response.data["data"]["user"]["avatar"];
        if (avatar != null) {
          avatar.replaceAll("\\", "");
          //avatar = "${AppUrls.backendStorage}/$avatar";
          debugPrint("avatar from response: $avatar");

          final directory = await getApplicationDocumentsDirectory();
          final imageExtension = avatar.split(".").last;
          final imageName =
              '${DateTime.now().millisecondsSinceEpoch}.$imageExtension';

          savePath = '${directory.path}/$imageName';

          await _dio.download(avatar, savePath);
        }

        int loginCount = response.data["data"]["user"]["login_count"] ?? 0;
        final user = User(
          id: response.data["data"]["user"]["id"],
          name: response.data["data"]["user"]["name"],
          email: email,
          password: password,
          bio: response.data["data"]["user"]["bio"] ?? "",
          loginCount: loginCount,
          image: savePath,
          token: token,
        );
        debugPrint("token: $token");

        // Save the user data to the database
        await _storageService.saveUserToStorage(user);
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to login: Unknown error');
      }
    } on DioException catch (e) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        e.stackTrace,
        reason: "Login failed with DioException",
        fatal: false,
      );
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    } catch (e, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: "Unexpected error during login",
        fatal: false,
      );

      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }
}
