import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/home/provider/home_provider.dart';
import 'package:lms_system/features/home/repository/home_repository.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final homeScreenApiNotifierProvider =
    Provider((ref) => HomeScreenApiNotifier(ref.read(homeRepositoryProvider)));

final homeScreenApiProvider =
    AsyncNotifierProvider<HomeScreenApiNotifier, List<Course>>(
  () {
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider,
      ],
    );
    return container.read(homeScreenApiNotifierProvider);
  },
);

class HomeScreenApiNotifier extends AsyncNotifier<List<Course>> {
  final HomeRepository _repository;

  HomeScreenApiNotifier(this._repository);

  @override
  Future<List<Course>> build() async {
    // Fetch and return the initial data
    return fetchHomeScreenData();
  }

  Future<List<Course>> fetchHomeScreenData() async {
    try {
      final courses = await _repository.getCourses();
      return courses; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
