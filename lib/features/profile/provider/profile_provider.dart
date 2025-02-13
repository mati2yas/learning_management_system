import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/profile/repository/profile_repository.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final profileControlerProvider =
    StateNotifierProvider<ProfileController, UserWrapper>((ref) {
  return ProfileController(ref.watch(profileRepositoryProvider));
});

class ProfileController extends StateNotifier<UserWrapper> {
  final ProfileRepository _repository;
  ProfileController(this._repository) : super(UserWrapper.initial());

  Future<String> editProfile() async {
    try {
      state = state.copyWith(apiState: ApiState.busy);

      final response = await _repository.editProfile(state);
      if (response.statusCode == 200) {
        state = state.copyWith(
            statusMsg: "Subscription successful", apiState: ApiState.idle);

        return "success, ${response.data["data"]}";
      } else {
        state = state.copyWith(statusMsg: "Subscription failed");
        return "error ${response.statusMessage}";
      }
    } catch (e) {
      state = state.copyWith(
          statusMsg: "An error occurred", apiState: ApiState.error);
      return "error";
    }
  }

  void updateBio(String newBio) {
    state = state.copyWith(bio: newBio);
  }

  void updateEmail(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateImagePath(String imagePath) {
    state = state.copyWith(image: imagePath);
  }

  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }
}
