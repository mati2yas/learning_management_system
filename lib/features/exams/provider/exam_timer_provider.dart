import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final examTimerProvider =
    StateNotifierProvider<FinalExamTimerNotifier, AsyncValue<int>>((ref) {
  return FinalExamTimerNotifier();
});

class FinalExamTimerNotifier extends StateNotifier<AsyncValue<int>> {
  Timer? _timer;

  FinalExamTimerNotifier() : super(const AsyncValue.data(0));

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resetTimer({required int duration}) {
    _timer?.cancel();
    state = AsyncValue.data(const Duration(minutes: 0).inSeconds);
    debugPrint("reset timer.");
    //startTimer(duration: duration);
  }

  void startTimer({required int duration}) {
    final endTime = DateTime.now().add(const Duration(minutes: 1));
    debugPrint("started timer.");
    resetTimer(duration: 0);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final now = DateTime.now();
        final remainingTime = endTime.difference(now).inSeconds;

        if (remainingTime <= 0) {
          state = const AsyncValue.data(0); // Time's up
          _timer?.cancel();
        } else {
          state = AsyncValue.data(remainingTime);
        }
      },
    );
  }
}
