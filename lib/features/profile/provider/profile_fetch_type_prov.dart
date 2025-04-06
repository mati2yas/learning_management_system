import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/enums.dart';

final profileFetchTypeProvider =
    StateNotifierProvider<ProfileFetchTypeNotifier, ProfileFetchType>(
  (ref) => ProfileFetchTypeNotifier(),
);

class ProfileFetchTypeNotifier extends StateNotifier<ProfileFetchType> {
  ProfileFetchTypeNotifier() : super(ProfileFetchType.localDb);

  void changeFetchType(ProfileFetchType newFetchType) {
    state = newFetchType;
  }
}
