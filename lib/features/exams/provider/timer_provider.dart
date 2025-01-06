import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final examTimerProvider =
    StateNotifierProvider<FinalExamTimerNotifier, AsyncValue<int>>((ref) {
  return FinalExamTimerNotifier();
});

class FinalExamTimerNotifier extends StateNotifier<AsyncValue<int>> {
  Timer? _timer;

  FinalExamTimerNotifier()
      : super(AsyncValue.data(const Duration(minutes: 5).inSeconds)) {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resetTimer() {
    _timer?.cancel();
    state = AsyncValue.data(const Duration(minutes: 5).inSeconds);
    startTimer();
  }

  void startTimer() {
    final endTime = DateTime.now().add(const Duration(minutes: 5));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final remainingTime = endTime.difference(now).inSeconds;

      if (remainingTime <= 0) {
        state = const AsyncValue.data(0); // Time's up
        _timer?.cancel();
      } else {
        state = AsyncValue.data(remainingTime);
      }
    });
  }
}
