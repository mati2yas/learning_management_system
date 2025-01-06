import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPlayingVideoTracker =
    StateNotifierProvider<CurrentPlayingVideoTracker, int>((ref) {
  return CurrentPlayingVideoTracker();
});

class CurrentPlayingVideoTracker extends StateNotifier<int> {
  CurrentPlayingVideoTracker() : super(0);

  void setCurrentIndex(int index) {
    state = index;
  }
}
