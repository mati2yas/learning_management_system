import 'package:lms_system/core/utils/db_service.dart';

class RegistrationStatusDataSource {
  final DatabaseService _databaseService;

  RegistrationStatusDataSource(this._databaseService);

  Future<void> clearRegistrationStatus() async {
    await _databaseService.deleteUser(1); // Assuming the user has an id of 1
  }

  Future<bool> isUserRegistered() async {
    final user = await _databaseService.getUserFromDatabase();
    return user != null;
  }
}
