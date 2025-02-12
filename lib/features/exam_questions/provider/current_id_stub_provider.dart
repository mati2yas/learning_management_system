import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentIdStubProvider =
    StateNotifierProvider<CurrentIdStubNotifier, Map<String, dynamic>>(
  (ref) => CurrentIdStubNotifier(),
);

class CurrentIdStubNotifier extends StateNotifier<Map<String, dynamic>> {
  CurrentIdStubNotifier()
      : super({
          "idType": "all",
          "id": 0,
        });
  void changeStub(Map<String, dynamic> newStub) {
    if (newStub["idType"] != null && newStub["id"] != null) {
      state = newStub;
    } else {
      debugPrint("stub has null values");
    }
  }
}
