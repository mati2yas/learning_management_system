import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';

final editProfileDataSourceProvider = Provider<EditProfileDataSource>(
    (ref) => EditProfileDataSource(DioClient.instance));

class EditProfileDataSource {
  final Dio _dio;

  EditProfileDataSource(this._dio);

  Future<void> editUserProfile({
    required String name,
    required String email,
    required String password,
    required String bio,
    required String image,
  }) async {
    int? statusCode;
    try {} on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
