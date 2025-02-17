import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  void toggleLiked(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            category: c.category,
            title: c.title,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes + (c.liked ? -1 : 1),
            image: c.image,
            saved: c.saved,
            liked: !c.liked,
            price: c.price,
            subscribed: c.subscribed,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }

  void toggleSaved(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            title: c.title,
            category: c.category,
            topics: c.topics,
            saves: c.saves + (c.saved ? -1 : 1),
            likes: c.likes,
            liked: c.liked,
            image: c.image,
            saved: !c.saved,
            subscribed: c.subscribed,
            price: c.price,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }

  void toggleSubscribed(Course course) {
    update((state) {
      return state.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            category: c.category,
            title: c.title,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes,
            image: c.image,
            saved: c.saved,
            subscribed: !c.subscribed,
            price: c.price,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }
}
