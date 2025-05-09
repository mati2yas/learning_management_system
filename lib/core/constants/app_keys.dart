import 'package:flutter/material.dart';

class AppKeys {
  static final drawerKey = GlobalKey<ScaffoldState>(debugLabel: "drawerKey");
  static final loginFormKey = GlobalKey<FormState>(debugLabel: "loginFormKey");
  static final registerScreenKey =
      GlobalKey<FormState>(debugLabel: "registerScreenKey");
  static final editProfileKey =
      GlobalKey<FormState>(debugLabel: "editProfileKey");

  static final forgotPasswordFormKey =
      GlobalKey<FormState>(debugLabel: "forgotPasswordKey");
  static final changePasswordFormKey =
      GlobalKey<FormState>(debugLabel: "changePasswordKey");
  static final changeEmailFormKey =
      GlobalKey<FormState>(debugLabel: "changeEmailKey");
}
