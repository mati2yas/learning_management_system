import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final editProfileDataSourceProvider = Provider<EditProfileDataSource>(
    (ref) => EditProfileDataSource(DioClient.instance));

class EditProfileDataSource {
  final Dio _dio;

  EditProfileDataSource(this._dio);

  Future<Response> editUserProfile(
    User user,
  ) async {
    int? statusCode;
    FormData formData = await user.toFormData();
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      _dio.options.headers['Accept'] = 'application/json';
      final response = await _dio.post(
        "/user-update",
        data: formData,
      );
      statusCode = response.statusCode;
      return response;
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
