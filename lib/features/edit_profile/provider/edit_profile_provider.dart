import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/repository/edit_profile_repository.dart';
import 'package:path_provider/path_provider.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileController, UserWrapper>((ref) =>
        EditProfileController(ref.watch(editProfileRepositoryProvider)));

class EditProfileController extends StateNotifier<UserWrapper> {
  final EditProfileRepository _repository;

  EditProfileController(this._repository) : super(UserWrapper.initial()) {
    _loadUser();
  }
  Future<String> editProfile() async {
    try {
      var usrr = await DatabaseService().getUserFromDatabase();

      state = state.copyWith(password: usrr?.password);
      state = state.copyWith(apiState: ApiState.busy);

      final response = await _repository.editProfile(state.toUser());

      final databaseService = DatabaseService();
      await databaseService.updateUserInDatabase(state.toUser());
      debugPrint("editProfController status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        state = state.copyWith(
            statusMsg: "Profile edit successful", apiState: ApiState.idle);

        return "success, ${response.data["data"]}";
      } else {
        state = state.copyWith(statusMsg: "Profile edit failed");
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

  void updateImage(XFile? image) async {
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imagePath = '${directory.path}/$imageName';
      await File(image.path).copy(imagePath);
      state = state.copyWith(image: imagePath);
    }
  }

  void updateImagePath(String imagePath) {
    state = state.copyWith(image: imagePath);
  }

  void updateName(String newName) {
    state = state.copyWith(name: newName);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  Future<void> _loadUser() async {
    final user = await UserWrapper.fromDb();
    state = user;
  }
}
