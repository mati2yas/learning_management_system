import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/app_router.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/custom_button.dart';
import 'package:lms_system/core/common_widgets/custom_dialog.dart';
import 'package:lms_system/core/common_widgets/custom_gap.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_keys.dart';
import 'package:lms_system/core/constants/enums.dart';
import 'package:lms_system/core/constants/fonts.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/edit_profile/presentation/widgets/check_password_dialog.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  XFile? profilePic;
  String? _errorMessageImagePath,
      _errorMessageName,
      _errorMessageEmail,
      _errorMessageBio,
      _errorMessagePassword;
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
        "editState = User{name: ${editState.name}, email: ${editState.email}, bio: ${editState.bio}, password: ${editState.password}}");

    double maxFormWidth = 400;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        titleText: "Edit Profile",
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 20,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: maxFormWidth,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: AppKeys.editProfileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: (profilePicPicked &&
                                      profilePic != null &&
                                      _errorMessageImagePath == null)
                                  ? Image.file(
                                      File(profilePic!.path),
                                      width: size.width,
                                      height: size.height * 0.25,
                                      fit: BoxFit.cover,
                                    )
                                  : (editState.image != "")
                                      ? Image.file(
                                          File(editState.image),
                                          width: size.width,
                                          height: size.height * 0.25,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          "assets/images/pfp-placeholder.jpg",
                                          width: size.width,
                                          height: size.height * 0.25,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.mainBlue2,
                                  foregroundColor: AppColors.mainBlue2,
                                  iconSize: 24,
                                ),
                                onPressed: () async {
                                  bool success = await pickProfilePic();

                                  if (success) {
                                    editProfileController
                                        .updateImage(profilePic);
                                    setState(() {
                                      profilePicPicked = true;
                                      //listViewSize = size.height * 0.35;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(
                          "Name",
                          style: textTh.bodyMedium!.copyWith(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      InputWidget(
                        onSaved: (value) {
                          editProfileController.updateName(value!);
                        },
                        onChanged: (value) {
                          if (_errorMessageName == null) {
                            editProfileController
                                .updateName(nameController.text);
                          }
                        },
                        hintText: "",
                        validator: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _errorMessageName = "Enter Proper Name";
                            });
                            return _errorMessageName;
                          }
                          setState(() {
                            _errorMessageName = null;
                          });
                          return null;
                        },
                        controller: nameController,
                      ),
                      Gap(),
                      _buildInputLabel("Email", textTh),

                      CustomButton(
                          isFilledButton: false,
                          buttonWidget: Text(
                            "Change your email",
                            style: textTheme.labelLarge!.copyWith(
                                letterSpacing: 0.5,
                                fontFamily: "Inter",
                                color: AppColors.mainBlue2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          buttonAction: () {
                            Navigator.of(context).pushNamed(Routes.changeEmail);
                          }),

                      // InputWidget(
                      //   onSaved: (value) {
                      //     editProfileController.updateEmail(value!);
                      //   },
                      //   onChanged: (value) {
                      //     if (_errorMessageEmail == null) {
                      //       editProfileController
                      //           .updateEmail(emailController.text);
                      //     }
                      //   },
                      //   hintText: "",
                      //   validator: (value) {
                      //     if (value.isEmpty) {
                      //       setState(() {
                      //         _errorMessageEmail = "Enter Proper Email";
                      //       });
                      //       return _errorMessageEmail;
                      //     }
                      //     setState(() {
                      //       _errorMessageEmail = null;
                      //     });
                      //     return null;
                      //   },
                      //   controller: emailController,
                      // ),

                      Gap(),
                      _buildInputLabel("Password", textTh),
                      CustomButton(
                          isFilledButton: false,
                          buttonWidget: Text(
                            "Change Password",
                            style: textTheme.labelLarge!.copyWith(
                                letterSpacing: 0.5,
                                fontFamily: "Inter",
                                color: AppColors.mainBlue2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          buttonAction: () {
                            debugPrint("user password: ${editState.password}");

                            showCustomDialog(
                              context: context,
                              title: 'Change Password',
                              content: CheckPassword(
                                password: editState.password,
                                email: editState.email,
                              ),
                              icon: Icons.password,
                              iconColor: Colors.red,
                              confirmText: 'Logout',
                              cancelText: 'Cancel',
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       content: CheckPassword(
                            //         password: editState.password,
                            //         email: editState.email,
                            //       ),
                            //     );
                            //   },
                            // );
                          }),

                      Gap(),
                      _buildInputLabel("Bio", textTh),
                      InputWidget(
                        onSaved: (value) {
                          editProfileController.updateBio(value!);
                        },
                        onChanged: (value) {
                          if (_errorMessageBio == null) {
                            editProfileController.updateBio(bioController.text);
                          }
                        },
                        maxLines: 5,
                        minLines: 3,
                        maxLength: 250,
                        hintText: "",
                        validator: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _errorMessageBio = "Please input Bio";
                            });
                            setState(() {
                              _errorMessageBio = null;
                            });
                            return _errorMessageBio;
                          }

                          return null;
                        },
                        controller: bioController,
                      ),
                      const SizedBox(height: 20),

                      CustomButton(
                          isFilledButton: true,
                          buttonWidget: editState.apiState == ApiState.busy
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : editState.apiState == ApiState.error
                                  ? Text(
                                      'Retry',
                                      style: textTheme.labelLarge!.copyWith(
                                          letterSpacing: 0.5,
                                          fontFamily: "Inter",
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                    )
                                  : Text(
                                      'Save',
                                      style: textTheme.labelLarge!.copyWith(
                                          letterSpacing: 0.5,
                                          fontFamily: "Inter",
                                          color: Colors.white,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                          buttonAction: () async {
                            _validateImagePath();
                            if (_errorMessageImagePath != null &&
                                user.image == "") {
                              setState(() {
                                profileEditSuccess = false;
                              });
                              return;
                            }
                            if (profilePicPicked) {
                              editProfileController.updateImage(profilePic);
                            }
                            if (AppKeys.editProfileKey.currentState
                                    ?.validate() ==
                                true) {
                              AppKeys.editProfileKey.currentState!.save();
                              try {
                                final result =
                                    await editProfileController.editProfile();
                                if (result.responseStatus) {
                                  setState(() {
                                    profileEditSuccess = true;
                                  });

                                  ref
                                      .read(profileProvider.notifier)
                                      .fetchUserData();
                                  nameController.clear();
                                  emailController.clear();
                                  bioController.clear();
                                  resetImagePicked();

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Profile Edit Successful!')),
                                    );

                                    Navigator.pop(context);
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    UtilFunctions.buildErrorSnackbar(
                                      errorMessage:
                                          'Profile Edit Failed: ${e.toString().replaceAll("Exception:", "")}',
                                      exception: e,
                                    ),
                                  );
                                }
                                profileEditSuccess = false;
                              }
                            }
                          }),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var prof = ref.read(editProfileProvider);
      nameController.text = prof.name;
      emailController.text = prof.email;
      passwordController.text = prof.password;
      bioController.text = prof.bio;
    });
  }

  void onConfirm(
    String enteredPassword,
    String editStatePassword,
    String userEmail,
  ) {
    if (enteredPassword == editStatePassword) {
      Navigator.of(context).pushNamed(
        Routes.forgotPasswordProfile,
        arguments: userEmail,
      );
    } else {
      // You might want to update the error message in the CheckPassword widget
      // or handle the error here. For simplicity, we'll just pop the dialog
      // and potentially show a snackbar.
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email does not match.")),
      );
    }
  }

  Future<bool> pickProfilePic() async {
    final XFile? image = await showImagePickSheet();
    if (image != null) {
      setState(() {
        profilePic = XFile(image.path);
        _errorMessageImagePath = null;
      });
      return true;
    }
    return false;
  }

  void resetImagePicked() {
    setState(() {
      profilePicPicked = false;
      profilePic = null;
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
                      _errorMessageImagePath = "Couldn't pick image.";
                    });
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
