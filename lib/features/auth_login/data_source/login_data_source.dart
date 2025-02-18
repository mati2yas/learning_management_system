import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        if (response.data["is_verified"] == false) {
          throw Exception("Email not verified");
        }

        final token = response.data["token"];
        String avatar = response.data["data"]["user"]["avatar"];
        avatar.replaceAll("\\", "");
        avatar = "https://lms.biruklemma.com/$avatar";
        debugPrint(avatar);

        final directory = await getApplicationDocumentsDirectory();
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savePath = '${directory.path}/$imageName';
        await _dio.download(avatar, savePath);

        final user = User(
          id: response.data["data"]["user"]["id"],
          name: response.data["data"]["user"]["name"],
          email: email,
          password: password,
          bio: response.data["data"]["user"]["bio"],
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
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
