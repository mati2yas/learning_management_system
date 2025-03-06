import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  XFile? profilePic;
  String? _errorMessageImagePath;
  bool profileEditSuccess = false;

  bool profilePicPicked = false;
  User user = User.initial();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final editProfileController = ref.watch(editProfileProvider.notifier);
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    final editState = ref.watch(editProfileProvider);
    debugPrint(
        "User{name: ${user.name}, email: ${user.email}, bio: ${user.bio}}");

    XFile? profilePic;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        titleText: "Edit Profile",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, profileEditSuccess);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 20,
        ),
        child: Form(
          key: AppKeys.editProfileKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.25,
                  child: Stack(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        child: user.image.isNotEmpty
                            ? Image.file(
                                File(user.image),
                                width: size.width,
                                height: size.height * 0.25,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/pfp-placeholder.jpg",
                                width: size.width,
                                height: size.height * 0.18,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.mainGrey,
                            foregroundColor: Colors.black,
                            iconSize: 24,
                          ),
                          onPressed: () async {
                            bool success = await pickProfilePic();

                            if (success) {
                              editProfileController.updateImage(profilePic);
                              setState(() {
                                profilePicPicked = true;
                                //listViewSize = size.height * 0.35;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildInputLabel("Name", textTh),
                InputWidget(
                  onSaved: (value) {
                    editProfileController.updateName(value!);
                  },
                  hintText: "",
                  validator: (value) {},
                  controller: nameController,
                ),
                _buildInputLabel("Email", textTh),
                InputWidget(
                  onSaved: (value) {
                    editProfileController.updateEmail(value!);
                  },
                  hintText: "",
                  validator: (value) {},
                  controller: emailController,
                ),
                _buildInputLabel("Password", textTh),
                InputWidget(
                  onSaved: (value) {
                    editProfileController.updatePassword(value!);
                  },
                  hintText: "",
                  validator: (value) {},
                  controller: passwordController,
                ),
                _buildInputLabel("Bio", textTh),
                InputWidget(
                  onSaved: (value) {
                    editProfileController.updateBio(value!);
                  },
                  maxLines: 2,
                  maxLength: 250,
                  hintText: "",
                  validator: (value) {},
                  controller: bioController,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      fixedSize: Size(size.width * 0.6, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      _validateImagePath();
                      if (_errorMessageImagePath != null && user.image == "") {
                        setState(() {
                          profileEditSuccess = true;
                        });
                        return;
                      }
                      if (profilePicPicked) {
                        editProfileController.updateImage(profilePic);
                      }
                      if (AppKeys.editProfileKey.currentState?.validate() ==
                          true) {
                        AppKeys.editProfileKey.currentState!.save();
                        try {
                          await editProfileController.editProfile();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Profile Edit Successful!')),
                            );
                          }
                          setState(() {
                            profileEditSuccess = true;
                          });
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Profile Edit Failed: $e')),
                            );
                          }
                          profileEditSuccess = false;
                        }
                      }
                    },
                    child: editState.apiState == ApiState.busy
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUser() async {
    final storageService = SecureStorageService();
    final usr = await storageService.getUserFromStorage();
    if (usr != null) {
      setState(() {
        user = usr;
        nameController.text = user.name;
        emailController.text = user.email;
        passwordController.text = user.password;
        bioController.text = user.bio;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<bool> pickProfilePic() async {
    final XFile? image = await showImagePickSheet();
    if (image != null) {
      setState(() {
        profilePic = XFile(image.path);
      });
      return true;
    }
    return false;
  }

  Future<XFile?> showImagePickSheet() async {
    final picker = ImagePicker();
    return await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          height: 150,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null && context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
                  child: Column(
                    spacing: 12,
                    children: [
                      Icon(Icons.camera),
                      Text("From Camera"),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null && context.mounted) {
                    Navigator.pop(context, image);
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
                  child: Column(
                    spacing: 12,
                    children: [
                      Icon(Icons.image),
                      Text("From Gallery"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputLabel(String label, TextTheme textTh) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: textTh.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _validateImagePath() {
    setState(() {
      if (!profilePicPicked) {
        _errorMessageImagePath = "This field cannot be empty";
      } else {
        _errorMessageImagePath = null;
      }
    });
  }
}
