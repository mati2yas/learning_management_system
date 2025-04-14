import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_strings.dart';

final currentIdStubProvider =
    StateNotifierProvider<CurrentIdStubNotifier, Map<String, dynamic>>(
  (ref) => CurrentIdStubNotifier(),
);

class CurrentIdStubNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentIdStubNotifier()
      : super({
          AppStrings.stubIdType: "all",
          AppStrings.stubId: 0,
        });
  void changeStub(Map<String, dynamic> newStub) {
    if (newStub[AppStrings.stubIdType] != null && newStub[AppStrings.stubId] != null) {
      state = newStub;
    } else {
      debugPrint("stub has null values");
    }
  }
}
