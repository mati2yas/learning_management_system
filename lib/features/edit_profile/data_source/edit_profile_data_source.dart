import 'package:dio/dio.dart';
import 'package:lms_system/core/utils/error_handling.dart';

class EditProfileDataSource {
  final Dio _dio;

  EditProfileDataSource(this._dio);

  Future<void> editUserProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    int? statusCode;
    try {} on DioException catch (e) {

      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
