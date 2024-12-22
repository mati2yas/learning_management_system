import 'package:flutter_riverpod/flutter_riverpod.dart';

final examTimerProvider = StreamProvider<int>((ref) async* {
  const examDuration = Duration(minutes: 5); // Example: 60 minutes
  final endTime = DateTime.now().add(examDuration);

  while (true) {
    final now = DateTime.now();
    final remainingTime = endTime.difference(now).inSeconds;

    if (remainingTime <= 0) {
      yield 0; // Time's up
      break;
    }

    yield remainingTime;
    await Future.delayed(const Duration(seconds: 1)); // Tick every second
  }
});
