import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class CurrentUserDataSource {
  final DatabaseService _databaseService;

  CurrentUserDataSource(this._databaseService);
  Future<User> getUser() async {
    final user = await _databaseService.getUserFromDatabase();
    if (user != null) {
      return user;
    } else {
      return User(
        name: "No name",
        email: "no email",
        password: "",
      );
    }
  }
}
