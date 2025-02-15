import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/features/edit_profile/model/edit_profile_state.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';

import '../../../../core/constants/colors.dart';

class ProfileAddScreen extends ConsumerStatefulWidget {
  const ProfileAddScreen({super.key});

  @override
  ConsumerState<ProfileAddScreen> createState() => _ProfileAddScreenState();
}

class _ProfileAddScreenState extends ConsumerState<ProfileAddScreen> {
  final TextEditingController _bioController = TextEditingController();
  String? _errorMessageBio;
  String name = "";
  XFile? avatarImage;
  bool imagePicked = false;
  String? _errorMessageImagePath;
  @override
  Widget build(BuildContext context) {
    final editProfileController = ref.watch(editProfileProvider.notifier);
    final editState = ref.watch(editProfileProvider);
    Size size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Text(
                'Welcome $name',
                style: textTh.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Let's complete your profile",
                style: textTh.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: size.height * .45,
                width: size.width - 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      'Bio',
                      style: textTh.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      controller: _bioController,
                      maxLines: 3,
                      maxLength: 250,
                      decoration: InputDecoration(
                        labelText: 'Tell us about yourself',
                        errorText: _errorMessageBio, // Show error message
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: AppColors.mainBlue,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onChanged: (value) {
                        // Validate on change
                        _validateInput();
                        if (_errorMessageBio == null) {
                          // if error message is null then _transactionIdController.text will not
                          // be null or empty.
                          editProfileController.updateBio(
                            _bioController.text,
                          );
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool success = await pickAvatarImage();

                        if (success) {
                          editProfileController.updateImage(avatarImage);
                          setState(() {
                            imagePicked = true;
                            //listViewSize = size.height * 0.35;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.mainBlue.withAlpha(100),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        height: 40,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Choose Profile Image",
                              style: TextStyle(
                                color: _errorMessageImagePath != null
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                            const Icon(
                              Icons.image,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (imagePicked &&
                        avatarImage != null &&
                        _errorMessageImagePath == null)
                      Image.file(
                        File(avatarImage!.path),
                        width: 60,
                        height: 60,
                      )
                    else if (_errorMessageImagePath != null)
                      Text(
                        _errorMessageImagePath!,
                        style: textTh.labelMedium!.copyWith(color: Colors.red),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.wrapper);
                      },
                      child: Text(
                        "Skip",
                        style: textTh.bodyLarge!.copyWith(
                          color: AppColors.mainBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //backgroundColor: Colors.black,
                        backgroundColor: AppColors.mainBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 15,
                        ),
                        fixedSize: const Size(140, 50),
                        minimumSize: const Size(100, 40),
                        maximumSize: const Size(180, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        _validateInput(); // Validate when button is pressed
                        _validateImagePath();
                        if (_errorMessageBio != null) {
                          return;
                        } else if (_errorMessageBio == null) {
                          final result =
                              await editProfileController.editProfile();
                          if (context.mounted) {
                            if (result.startsWith("success")) {
                              resetImagePicked();
                              _bioController.clear();

                              // we need this so that next time home page fetches
                              // courses that are not bought.
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.contains("success")
                                    ? "Edit Profile successful!"
                                    : "Edit Profile failed!"),
                                backgroundColor: result == "success"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          }
                        }
                        Navigator.of(context)
                            .pushReplacementNamed(Routes.profileAdd);
                      },
                      child: editState.apiState == ApiState.busy
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Submit',
                              style: textTh.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getUserName() async {
    final databaseService = DatabaseService();
    final user = await databaseService.getUserFromDatabase();
    if (user != null) {
      name = user.name;
    } else {
      name = "No name";
    }
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<bool> pickAvatarImage() async {
    final XFile? image = await showImagePickSheet();
    if (image != null) {
      avatarImage = XFile(image.path);
      setState(() {
        _errorMessageImagePath = null;
      });
      return true;
    }
    return false;
  }

  void resetImagePicked() {
    setState(() {
      imagePicked = false;
      avatarImage = null;
    });
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
                  try {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null && context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessageImagePath = e.toString();
                    });
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
                  child: Column(
                    children: [
                      Icon(Icons.camera),
                      Text("From Camera"),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null && context.mounted) {
                      Navigator.pop(context, image);
                    }
                  } catch (e) {
                    setState(() {
                      _errorMessageImagePath = e.toString();
                    });
                  }
                },
                child: const SizedBox(
                  height: 80,
                  width: 120,
                  child: Column(
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

  void _validateImagePath() {
    setState(() {
      if (!imagePicked) {
        _errorMessageImagePath = "This field cannot be empty";
      } else {
        _errorMessageImagePath = null;
      }
    });
  }

  void _validateInput() {
    setState(() {
      // Example validation: Check if the input is empty
      if (_bioController.text.isEmpty) {
        _errorMessageBio = 'This field cannot be empty';
      } else {
        _errorMessageBio = null; // Clear error message if valid
      }
    });
  }
}
