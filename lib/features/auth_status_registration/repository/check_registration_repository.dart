
import 'package:lms_system/features/auth_status_registration/data_source/check_registered_data_source.dart';

class RegistrationStatusRepository {
  final RegistrationStatusDataSource _dataSource;

  RegistrationStatusRepository(this._dataSource);

  Future<bool> isUserRegistered() {
    return _dataSource.isUserRegistered();
  }

  Future<void> clearRegistrationStatus() {
    return _dataSource.clearRegistrationStatus();
  }
}
