import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';
import 'package:path_provider/path_provider.dart';

final editProfileDataSourceProvider = Provider<EditProfileDataSource>(
    (ref) => EditProfileDataSource(DioClient.instance, SecureStorageService()));

class EditProfileDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  EditProfileDataSource(this._dio, this._storageService);

  Future<Response> editUserProfile(
    User user,
  ) async {
    int? statusCode;
    FormData formData = await user.toFormData();

    debugPrint("client token: [${_dio.options.headers["Authorization"]}]");
    await DioClient.setToken();
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      _dio.options.headers['Accept'] = 'application/json';
      final response = await _dio.post(
        AppUrls.editProfile,
        data: formData,
      );
      String password = "";
      var intMap = formData.fields.asMap();
      for (var entry in intMap.entries) {
        var entVal = entry.value;
        if (entVal.key == "password") {
          password = entVal.value;
        }
      }
      statusCode = response.statusCode;
      String savePath = "";
      final token = response.data["token"] ?? "No token";
      //debugPrint("login token: $token");
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
      var name = response.data["data"]["user"]["name"];
      var email = response.data["data"]["user"]["email"];
      debugPrint(
          "User after edit: User(name: $name, email: $email, password: $password, token: $token)");

      final user = User(
        id: response.data["data"]["user"]["id"],
        name: response.data["data"]["user"]["name"],
        email: response.data["data"]["user"]["email"],
        password: password,
        bio: response.data["data"]["user"]["bio"] ?? "",
        image: savePath,
        token: token,
      );
      debugPrint("token: $token");

      // Save the user data to the database
      await _storageService.saveUserToStorage(user);
      await Future.delayed(const Duration(seconds: 2));
      //await _storageService.saveUserToStorage(user);
      return response;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
