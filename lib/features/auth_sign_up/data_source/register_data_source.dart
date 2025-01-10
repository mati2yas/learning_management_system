import 'package:dio/dio.dart';

class RegisterDataSource {
  final Dio _dio;

  RegisterDataSource(this._dio);

  Future<void> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/student-registration', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
