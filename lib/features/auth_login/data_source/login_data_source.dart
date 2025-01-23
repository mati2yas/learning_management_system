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

      if (response.statusCode == 200) {
        final token = response.data['token'];
        final user = response.data['data']['user'];
        // for (int i = 0; i < 50; ++i) {
        //   print(response.data['data']);
        // }
        // var name = user["name"];

        // final prefs = await SharedPreferences.getInstance();
        // final valueData = jsonEncode({
        //   "name": "\"$name\"",
        //   "email": "\"$email\"",
        //   "token": "\"$token\"",
        //   "password": "\"$password\"",
        // });

        print("User Data to Save:");
        // print(valueData);

        // // Save the JSON string
        // await prefs.setString("userData", valueData);
      } else {
        throw Exception('Failed to register user');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
