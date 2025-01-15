import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/edit_profile/data_source/edit_profile_data_source.dart';
import 'package:lms_system/features/edit_profile/repository/edit_profile_repository.dart';

final editProfileDataSourceProvider = Provider<EditProfileDataSource>((ref) {
  return EditProfileDataSource(DioClient.instance);
});

final editProfileRepositoryProvider = Provider<EditProfileRepository>((ref) {
  return EditProfileRepository(ref.watch(editProfileDataSourceProvider));
});

class EditProfileRepositoryProvider {}
