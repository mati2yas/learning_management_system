import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/core/utils/storage_service.dart';
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

    var usrr = await SecureStorageService().getUserFromStorage();
    state = state.copyWith(password: usrr?.password);
    state = state.copyWith(apiState: ApiState.busy);
    if (usrr?.token != null) {
      await DioClient.setToken();

      state = state.copyWith(token: usrr?.token);
    }
    try {
      var user = state.toUser();
      debugPrint("user bio: ${user.bio}, user pfp: ${user.image}");
      debugPrint(user.toString());

      //final databaseService = DatabaseService();
      final storageService = SecureStorageService();
      //await databaseService.updateUserBioAndPfp(user, user.bio, user.image);
      //await storageService.updateUserBioAndPfp(user, user.bio, user.image);

      await storageService.updateUserInStorage(user);

      final newUser = await storageService.getUserFromStorage();
      debugPrint(
          "user after... User{name: ${newUser?.name}, bio: ${newUser?.bio}, image: ${newUser?.image}}");

      final response = await _repository.editProfile(user);
      statusCode = response.statusCode;
      debugPrint("editProfController status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        state = state.copyWith(
            statusMsg: "Profile edit successful", apiState: ApiState.idle);

        (responseMessage, responseStatus) =
            (response.data["message"], response.data["status"]);
      } else {
        state = state.copyWith(statusMsg: "Profile edit failed");

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
