import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/shared/model/start_routes.dart';

final startRoutesProvider =
    StateNotifierProvider<InitialRouteNotifier, StartRoutes>((ref) {
  return InitialRouteNotifier();
});

class InitialRouteNotifier extends StateNotifier<StartRoutes> {
  InitialRouteNotifier() : super(StartRoutes.initial());
  void changeRoute({String? firstRoute, String? secondRoute}) {
    state = state.copyWith(firstRoute: firstRoute, secondRoute: secondRoute);
  }
}
