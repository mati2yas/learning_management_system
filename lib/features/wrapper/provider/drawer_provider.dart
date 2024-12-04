import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawerButtonProvider =
    StateNotifierProvider<DrawerButtonController, DrawerType>((ref) {
  return DrawerButtonController();
});

class DrawerButtonController extends StateNotifier<DrawerType> {
  DrawerButtonController() : super(DrawerType.home);

  void changeDrawerType(DrawerType type) => state = type;
}

enum DrawerType { home, other }
