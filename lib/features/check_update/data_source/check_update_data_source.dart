import 'package:dio/dio.dart';
import 'package:lms_system/features/check_update/model/check_update_model.dart';

class AppUpdateApiService {
  Future<AppUpdateStatus> fetchUpdateInfoFromBackend() async {
    try { 
      final dio = Dio();

      // Replace with your actual API call
      // final response = await dio.get(AppUrls.appLatestUpdate).timeout(Duration(seconds: 5));
      // if (response.statusCode == 200) {
      //   return AppUpdateStatus.fromJson(response.data);
      // }

      throw Exception("Invalid response from server");
    } catch (e) {
      return AppUpdateStatus.fromJson({
        "code": "latest_version",
        "latest_version": {
          "name": "Android 1.0.0",
          "slug": "1",
          "description": "this is default update type",
          "is_critical": true
        }
      });
    }
  }
}
