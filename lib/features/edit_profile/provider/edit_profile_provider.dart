import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/repository/edit_profile_repository.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';
import 'package:path_provider/path_provider.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileController, UserWrapper>((ref) =>
        EditProfileController(ref.watch(editProfileRepositoryProvider)));

class EditProfileController extends StateNotifier<UserWrapper> {
  final EditProfileRepository _repository;

  EditProfileController(this._repository) : super(UserWrapper.initial()) {
    _loadUser();
  }
  Future<ApiResponse> editProfile() async {
    String responseMessage = "";
    bool responseStatus = false;
    int? statusCode;

    state = state.copyWith(apiState: ApiState.busy);
    await DioClient.setToken();

    try {
      var user = state.toUser();
      debugPrint(user.toString());

      debugPrint(
          "user in state: User(password: ${user.password}, bio: ${user.bio}, image: ${user.image})");

      final response = await _repository.editProfile(user);
      statusCode = response.statusCode;
      //debugPrint("editProfController status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        (responseMessage, responseStatus) =
            (response.data["message"], response.data["status"]);

        state = state.copyWith(
            statusMsg: "Profile edit successful", apiState: ApiState.idle);
        //debugPrint("user: ${response.data["user"] ?? {"no user": "yes"}}");
      } else {
        state = state.copyWith(
          statusMsg: "Profile edit failed",
          apiState: ApiState.error,
        );

        (responseMessage, responseStatus) =
            (response.data["message"], response.data["status"]);
      }
    } on Exception catch (e) {
      state = state.copyWith(
          statusMsg: ApiExceptions.getExceptionMessage(e, statusCode),
          apiState: ApiState.error);

      (responseMessage, responseStatus) = (state.statusMsg, false);
    }
    return ApiResponse(
        message: responseMessage, responseStatus: responseStatus);
  }

  void updateBio(String newBio) {
    //debugPrint("state bio before update: ${state.bio}");
    state = state.copyWith(bio: newBio);
    //debugPrint("state bio before update: ${state.bio}");
  }

  void updateEmail(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateImage(XFile? image) async {
    //debugPrint("state imagePath before update: ${state.image}");
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final imagePath = '${directory.path}/$imageName';
      await File(image.path).copy(imagePath);
      state = state.copyWith(image: imagePath);
    }
    //debugPrint("state imagePath after update: ${state.image}");
  }

  void updateName(String newName) {
    //debugPrint("state name before update: ${state.name}");
    state = state.copyWith(name: newName);
    //debugPrint("state name before update: ${state.name}");
  }

  void updatePassword(String password) {
    //debugPrint("state pass before update: ${state.password}");
    state = state.copyWith(password: password);
    //debugPrint("state pass after update: ${state.password}");
  }

  Future<void> _loadUser() async {
    final user = await UserWrapper.fromStorage();
    state = user;
  }
}
