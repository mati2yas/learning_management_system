import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      final response = await _dio.post('/student-register', data: {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response.statusCode == 200 && response.data['status'] == true) {
        // Parse and store the token and user data in SharedPreferences
        final token = response.data['token'];
        final user = response.data['data']['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        // the json format of the code
        String valueData = "{"
            "'name': $name,"
            " 'email': $email,"
            " 'token': $token"
            "}";
        print("user valdata:");
        print(valueData);

        await prefs.setString("userData", valueData);
      } else {
        throw Exception('Failed to register user: ${response.data['message']}');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
