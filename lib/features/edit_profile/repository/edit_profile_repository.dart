import 'package:lms_system/features/edit_profile/data_source/edit_profile_data_source.dart';

class EditProfileRepository {
  final EditProfileDataSource _dataSource;

  EditProfileRepository(this._dataSource);

  Future<void> editProfile({
    required String name,
    required String email,
    required String password,
  }) {
    return _dataSource.editUserProfile(
      name: name,
      email: email,
      password: password,
    );
  }
}
