import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/home/data_source/home_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class HomeRepository {
  final HomeDataSource _dataSource;
  final ConnectivityService _connectivityService;
  HomeRepository(this._dataSource, this._connectivityService);

  Future<List<Course>> getCourses() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.getCourses();
  }
}
