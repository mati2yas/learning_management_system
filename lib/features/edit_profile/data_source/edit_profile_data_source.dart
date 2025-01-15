import 'package:dio/dio.dart';

class EditProfileDataSource {
  final Dio _dio;

  EditProfileDataSource(this._dio);

  Future<void> editUserProfile({
    required String name,
    required String email,
    required String password,
  }) async {
    try {} on DioException catch (e) {
      throw Exception("API error: ${e.response?.data['message'] ?? e.message}");
    }
  }
}
