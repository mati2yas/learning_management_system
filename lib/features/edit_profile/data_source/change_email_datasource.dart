import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/edit_profile/provider/change_email_provider.dart';

final changeEmailDataSourceProvider = Provider<ChangeEmailDataSource>((ref) {
  return ChangeEmailDataSource(
    DioClient.instance,
    SecureStorageService(),
  );
});

class ChangeEmailDataSource {
  final Dio _dio;
  final SecureStorageService _storageService;

  ChangeEmailDataSource(this._dio, this._storageService);

  Future<Response?> changeEmail({required String email}) async {
    int? statusCode;
    Response? response;
    ChangeEmailState changeEmailState = ChangeEmailState(email: email);
    try {
      //debugPrint("forgot password, is email null?");
      await DioClient.setToken();
      response = await _dio.post(
        AppUrls.changeEmail,
        data: {
          "email": email,
        },
      );
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        changeEmailState = ChangeEmailState(
          email: email,
        );
        //await _storageService.saveForgotPassData(forgotPassData);
      } else if (response.statusCode == 403) {
        var msg = response.data["message"] ?? "Error Message?";
        throw Exception(msg);
      } else {
        throw Exception('Failed to reset password: Unknown error');
      }
    } on DioException catch (e) {
      //debugPrint("dio exception at forgot password");
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return response;
  }
}
