import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/repository/edit_profile_repository.dart';

final editProfileProvider =
    StateNotifierProvider<EditProfileController, EditProfileState>((ref) =>
        EditProfileController(ref.watch(editProfileRepositoryProvider)));
class EditProfileController extends StateNotifier<EditProfileState> {
  final EditProfileRepository _repository;

  EditProfileController(this._repository) : super(EditProfileState());

  Future<void> editProfile() async {
    final Map<String, dynamic> updatedData = {};
    if (state.name.isNotEmpty) updatedData['name'] = state.name;
    if (state.email.isNotEmpty) updatedData['email'] = state.email;
    if (state.password.isNotEmpty) updatedData['password'] = state.password;
    if (state.bio.isNotEmpty) updatedData['bio'] = state.bio;
    if (state.image.isNotEmpty) updatedData['image'] = state.image;

    if (updatedData.isEmpty) return;

    try {
      await _repository.editProfile(updateData: updatedData);
    } catch (e) {
      rethrow;
    }
  }

  void updateBio(String value) => state = state.copyWith(bio: value);
  void updateEmail(String value) => state = state.copyWith(email: value);
  void updateImage(String value) => state = state.copyWith(image: value);
  void updateName(String value) => state = state.copyWith(name: value);
  void updatePassword(String value) => state = state.copyWith(password: value);
}
// class EditProfileController extends StateNotifier<EditProfileState> {
//   final EditProfileRepository _repository;

//   EditProfileController(this._repository) : super(EditProfileState()) {
//     getInitialState();
//   }

//   Future<void> editProfile() async {
//     try {
//       await _repository.editProfile(
//         name: state.name,
//         email: state.email,
//         password: state.password,
//         bio: state.bio,
//         image: state.image,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> getInitialState() async {
//     state = await EditProfileState.initial();
//   }

//   void updateBio(String? value) {
//     if (value == null || value.isEmpty) {
//       return;
//     }
//     state = state.copywith(password: value);
//   }

//   void updateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return;
//     }
//     state = state.copywith(email: value);
//   }

//   void updateImage(String? value) {
//     if (value == null || value.isEmpty) {
//       return;
//     }
//     state = state.copywith(password: value);
//   }

//   void updateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return;
//     }
//     state = state.copywith(name: value);
//   }

//   void updatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return;
//     }
//     state = state.copywith(password: value);
//   }
// }
