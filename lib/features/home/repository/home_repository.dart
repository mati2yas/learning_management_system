import 'package:lms_system/features/home/data_source/home_data_source.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class HomeRepository {
  final HomeDataSource _dataSource;
  HomeRepository(this._dataSource);

  Future<List<Course>> getCourses() async {
    return await _dataSource.getCourses();
  }
}
