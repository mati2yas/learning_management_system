import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/edit_profile/data_source/edit_profile_data_source.dart';

final editProfileRepositoryProvider = Provider<EditProfileRepository>(
    (ref) => EditProfileRepository(ref.watch(editProfileDataSourceProvider),),);

class EditProfileRepository {
  final EditProfileDataSource _dataSource;

  EditProfileRepository(this._dataSource);

  Future<void> editProfile({
    required Map<String, dynamic> updateData, 
  }) {
    return _dataSource.editUserProfile(
      name: updateData["name"],
      email:  updateData["email"],
      password:  updateData["password"],
      image:  updateData["image"],
      bio:  updateData["bio"],
    );
  }
}
