import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final examTimerProvider =
    StateNotifierProvider<FinalExamTimerNotifier, AsyncValue<int>>((ref) {
  return FinalExamTimerNotifier();
});

class FinalExamTimerNotifier extends StateNotifier<AsyncValue<int>> {
  Timer? _timer;

  FinalExamTimerNotifier()
      : super(AsyncValue.data(const Duration(minutes: 20).inSeconds)) {
    startTimer(30);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void resetTimer({required int duration}) {
    _timer?.cancel();
    state = AsyncValue.data(const Duration(minutes: 0).inSeconds);
    startTimer(duration);
  }

  void startTimer(int duration) {
    final endTime = DateTime.now().add(Duration(minutes: duration));

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
