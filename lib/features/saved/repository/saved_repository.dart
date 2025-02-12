import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/saved/data_source/saved_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';



class SavedRepository {
  final SavedDataSource _dataSource;
  final ConnectivityService _connectivityService;
  SavedRepository(this._dataSource, this._connectivityService);

  Future<List<Course>> getCourses() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.getCourses();
  }
}
