import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/auth_status_registration/provider/auth_status_controller.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../../../../core/constants/app_colors.dart';

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
    final authStatusController = ref.watch(authStatusProvider.notifier);
    Size size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Welcome $name',
          style: const TextStyle(
            color: AppColors.mainBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing:
                        constraints.maxWidth < constraints.maxHeight ? 30 : 20,
                    children: [
                      // Text(
                      //   'Welcome $name',
                      //   style: textTh.headlineMedium!.copyWith(
                      //     fontWeight: FontWeight.w800,
                      //   ),
                      // ),
                      Text(
                        "Let's complete your profile",
                        style: textTh.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                          style:
                              textTh.labelMedium!.copyWith(color: Colors.red),
                        ),
                      // SizedBox(
                      //   height: size.height * .45,
                      //   width: size.width - 80,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     spacing: 12,
                      //     children: [

                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextButton(
                                onPressed: () async {

                                  if (context.mounted) {
                                    Navigator.of(context).pushReplacementNamed(
                                      Routes.wrapper,
                                    );
                                  }
                                },
                                child: Text(
                                  "Skip",
                                  style: textTh.bodyLarge!.copyWith(
                                    color: AppColors.mainBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //backgroundColor: Colors.black,
                                  backgroundColor: AppColors.mainBlue,
                                  padding: editState.apiState == ApiState.busy
                                      ? null
                                      : const EdgeInsets.symmetric(
                                          horizontal: 50,
                                          vertical: 10,
                                        ),

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
                                    final result = await editProfileController
                                        .editProfile();
                                    if (result.responseStatus) {
                                      resetImagePicked();
                                      _bioController.clear();
                                      authStatusController.checkAuthStatus();
                                    }
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(result.message),
                                          backgroundColor: result.responseStatus
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                  if (context.mounted) {
                                    Navigator.of(context)
                                        .pushReplacementNamed(Routes.home);
                                  }
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
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> getUserName() async {
    final storageService = SecureStorageService();
    final user = await storageService.getUserFromStorage();
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
                      _errorMessageImagePath = "Couldn't Pick image";
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
                      _errorMessageImagePath = "Couldn't pick image";
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
