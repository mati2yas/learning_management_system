import 'package:lms_system/features/current_user/data_source/current_user_data_source.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class CurrentUserRepository {
  final CurrentUserDataSource _dataSource;
  CurrentUserRepository(this._dataSource);
  Future<User> getUser() {
    return _dataSource.getUser();
  }
}
