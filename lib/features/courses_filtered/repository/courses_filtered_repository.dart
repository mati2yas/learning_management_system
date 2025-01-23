import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/courses_filtered/data_source/courses_filtered_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CoursesFilteredRepository {
  final CoursesFilteredDataSource _dataSource;
  final ConnectivityService _connectivityService;

  CoursesFilteredRepository(this._dataSource, this._connectivityService);

  Future<List<Course>> fetchCourses({required String filter}) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }

    return await _dataSource.fetchCoursesFiltered(filter);
  }
}
