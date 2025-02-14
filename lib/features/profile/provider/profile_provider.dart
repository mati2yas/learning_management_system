import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/profile/provider/profile_fetch_type_prov.dart';
import 'package:lms_system/features/profile/repository/profile_repository.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final profileNotifierProvider = Provider(
  (ref) => ProfileController(
    ref.read(profileRepositoryProvider),
  ),
);

final profileProvider = AsyncNotifierProvider<ProfileController, User>(() {
  final container = ProviderContainer(overrides: [
    profileRepositoryProvider,
  ]);
  return container.read(profileNotifierProvider);
});

class ProfileController extends AsyncNotifier<User> {
  final ProfileRepository _repository;

  ProfileController(this._repository);

  @override
  Future<User> build() async {
    return fetchUserData();
  }

  Future<User> fetchUserData() async {
    User user = User.initial();
    final fetchType = ref.read(profileFetchTypeProvider);
    state = const AsyncValue.loading();
    try {
      user = await _repository.fetchUserData(fetchType);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
    return user;
  }
}
