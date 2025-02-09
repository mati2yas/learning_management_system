import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/saved/data_source/saved_data_source.dart';
import 'package:lms_system/features/saved/repository/saved_repository.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final savedApiNotifierProvider =
    Provider((ref) => SavedApiNotifier(ref.read(savedRepositoryProvider)));

final savedApiProvider =
    AsyncNotifierProvider<SavedApiNotifier, List<Course>>(() {
  final container = ProviderContainer(
    overrides: [
      savedRepositoryProvider,
    ],
  );
  return container.read(savedApiNotifierProvider);
});

final savedDataSourceProvider = Provider<SavedDataSource>((ref) {
  return SavedDataSource(DioClient.instance);
});

final savedRepositoryProvider = Provider<SavedRepository>((ref) {
  return SavedRepository(
    ref.watch(savedDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class SavedApiNotifier extends AsyncNotifier<List<Course>> {
  final SavedRepository _repository;
  SavedApiNotifier(this._repository);

  @override
  FutureOr<List<Course>> build() {
    return fetchSavedCoursesData();
  }

  Future<List<Course>> fetchSavedCoursesData() async {
    state = const AsyncLoading();
    try {
      final courses = await _repository.getCourses();
      state = AsyncData(courses);
      return courses; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
