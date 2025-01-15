import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_repository_provider.dart';
import 'package:lms_system/features/edit_profile/repository/edit_profile_repository.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileController, EditProfileState>((ref) =>
        EditProfileController(ref.watch(editProfileRepositoryProvider)));

class EditProfileController extends StateNotifier<EditProfileState> {
  final EditProfileRepository _repository;

  EditProfileController(this._repository) : super(EditProfileState()) {
    getInitialState();
  }

  Future<void> editProfile() async {
    try {
      await _repository.editProfile(
        name: state.name,
        email: state.email,
        password: state.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getInitialState() async {
    state = await EditProfileState.initial();
  }

  void updateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    state = state.copywith(email: value);
  }

  void updateName(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    state = state.copywith(name: value);
  }

  void updatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return;
    }
    state = state.copywith(password: value);
  }
}
