import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/edit_profile/data_source/edit_profile_data_source.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final editProfileRepositoryProvider = Provider<EditProfileRepository>(
  (ref) => EditProfileRepository(
    ref.watch(editProfileDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

class EditProfileRepository {
  final EditProfileDataSource _dataSource;
  final ConnectivityService _connectivityService;

  EditProfileRepository(this._dataSource, this._connectivityService);

  Future<Response> editProfile(User user) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.editUserProfile(user);
  }
}
