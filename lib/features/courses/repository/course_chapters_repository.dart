import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/courses/data_source/course_chapters_data_source.dart';
import 'package:lms_system/features/shared/model/chapter.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CourseChaptersRepository {
  final CourseChaptersDataSource _dataSource;
  final ConnectivityService _connectivityService;

  CourseChaptersRepository(this._dataSource, this._connectivityService);

  Future<List<Chapter>> fetchCourseChapters(String courseId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }

    return await _dataSource.fetchCourseChapters(courseId);
  }
}
