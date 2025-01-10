import 'package:dio/dio.dart';

class LoginDataSource {
  final Dio _dio;

  LoginDataSource(this._dio);

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode != 200) {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
