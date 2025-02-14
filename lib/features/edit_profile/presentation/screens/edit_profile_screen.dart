import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';
import 'package:lms_system/features/profile/provider/profile_provider.dart';

final editProfileKey = GlobalKey<FormState>();

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  XFile? profilePic;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;
    XFile? profilePic;
    final editProfileController = ref.watch(editProfileProvider.notifier);
    final state = ref.watch(editProfileProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(titleText: "Edit Profile"),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 20,
        ),
        child: Form(
          key: editProfileKey,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.4,
                height: size.height * 0.2,
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: profilePic != null
                          ? FileImage(File(profilePic.path))
                          : const AssetImage("assets/images/profile_pic.png")
                              as ImageProvider,
                      radius: 80,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.mainGrey,
                          foregroundColor: Colors.black,
                          iconSize: 24,
                        ),
                        onPressed: () async {
                          bool imagePicked = await pickProfilePic();
                          if (imagePicked) {
                            editProfileController.updateImage(profilePic!.path);
                          }
                        },
                        icon: const Icon(Icons.image),
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
                  initialValue: state.name),
              _buildInputLabel("Email", textTh),
              InputWidget(
                  onSaved: (value) {
                    editProfileController.updateEmail(value!);
                  },
                  hintText: "",
                  validator: (value) {},
                  initialValue: state.email),
              _buildInputLabel("Password", textTh),
              InputWidget(
                onSaved: (value) {
                  editProfileController.updatePassword(value!);
                },
                hintText: "",
                validator: (value) {},
                initialValue: state.password,
              ),
              _buildInputLabel("Bio", textTh),
              InputWidget(
                onSaved: (value) {
                  editProfileController.updateBio(value!);
                },
                hintText: "",
                validator: (value) {},
                initialValue: "mati",
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainBlue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    fixedSize: Size(size.width * 0.45, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // if (editProfileKey.currentState?.validate() == true) {
                    //   editProfileKey.currentState!.save();
                    //   try {
                    //     await editProfileController.editProfile();
                    //     if (context.mounted) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         const SnackBar(
                    //           content: Text('Profile Edit Successful!'),
                    //         ),
                    //       );
                    //     }
                    //   } catch (e) {
                    //     if (context.mounted) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           content: Text('Profile Edit Failed: $e'),
                    //         ),
                    //       );
                    //     }
                    //   }
                    if (editProfileKey.currentState?.validate() == true) {
                      editProfileKey.currentState!.save();
                      try {
                        await editProfileController.editProfile();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile Edit Successful!')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile Edit Failed: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text(
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
    );
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
}
