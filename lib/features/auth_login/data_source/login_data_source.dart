import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final loginDataSourceProvider = Provider<LoginDataSource>((ref) {
  return LoginDataSource(DioClient.instance, DatabaseService());
});

class LoginDataSource {
  final Dio _dio;
  final DatabaseService _databaseService;

  LoginDataSource(this._dio, this._databaseService);

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    int? statusCode;
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      statusCode = response.statusCode;

      if (response.statusCode == 200) {
        if (response.data["is_verified"] == false) {
          throw Exception("Email not verified");
        }

        final token = response.data["token"];
        final user = User(
          id: response.data["data"]["user"]["id"],
          name: response.data["data"]["user"]["name"],
          email: email,
          password: password,
          token: token,
        );

        // Save the user data to the database
        await _databaseService.saveUserToDatabase(user);
      } else if (response.statusCode == 403) {
        var msg = response.data["message"];
        throw Exception(msg);
      } else {
        throw Exception('Failed to login: Unknown error');
      }
    } on DioException catch (e) {
      String errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
  }
}
