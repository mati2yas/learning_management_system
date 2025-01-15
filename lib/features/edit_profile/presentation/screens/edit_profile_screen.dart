import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/core/common_widgets/input_field.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/edit_profile/provider/edit_profile_provider.dart';

final editProfileKey = GlobalKey<FormState>();

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    var textTh = Theme.of(context).textTheme;

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
                    const CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/profile_pic.png"),
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
                        onPressed: () {},
                        icon: const Icon(Icons.image),
                      ),
                    ),
                  ],
                ),
              ),
              _buildInputLabel("Name", textTh),
              InputWidget(
                onSaved: (value) {
                  editProfileController.updateName(value);
                },
                hintText: "",
                validator: (value) {},
                initialValue: "mati",
              ),
              _buildInputLabel("Email", textTh),
              InputWidget(
                onSaved: (value) {
                  editProfileController.updateEmail(value);
                },
                hintText: "",
                validator: (value) {},
                initialValue: "mati",
              ),
              _buildInputLabel("Password", textTh),
              InputWidget(
                onSaved: (value) {
                  editProfileController.updatePassword(value);
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
                    if (editProfileKey.currentState?.validate() == true) {
                      editProfileKey.currentState!.save();
                      try {
                        await editProfileController.editProfile();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registration Successful!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration Failed: $e'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
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
