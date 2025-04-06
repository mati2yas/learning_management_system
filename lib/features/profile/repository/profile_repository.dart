import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/profile/data_source/profile_data_source.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    ref.watch(profileDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

class ProfileRepository {
  final ProfileDataSource _dataSource;
  final ConnectivityService _connectivityService;
  ProfileRepository(this._dataSource, this._connectivityService);

  Future<User> fetchUserData(ProfileFetchType fetchType) async {
    if (fetchType == ProfileFetchType.localDb) {
      User? user =
          await _dataSource.fetchProfileFromDatabase() ?? User.initial();
      return user;
    }

    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.fetchProfileFromBackend();
  }
}
