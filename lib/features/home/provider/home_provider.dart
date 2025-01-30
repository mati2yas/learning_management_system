import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/home/data_source/home_data_source.dart';
import 'package:lms_system/features/home/repository/home_repository.dart';
import 'package:riverpod/riverpod.dart';

import '../../shared/model/shared_course_model.dart';
import '../../shared/model/shared_user.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource(DioClient.instance);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    ref.watch(homeDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

final pageviewPartsProvider = Provider<Map<String, String>>((ref) {
  return {
    "tag": "What would you like to learn today ?",
    "img": "university.png"
  };
});

final userProvider = Provider<User>((ref) {
  return User(
    name: "Biruk",
    lastName: "Lemma",
    email: "Biruk@gmail.com",
    password: "123",
    bio: "mi casa es tu casa",
    image: "image.png",
  );
});

class HomeNotifier extends StateNotifier<AsyncValue<List<Course>>> {
  final HomeRepository repository;

  HomeNotifier(this.repository) : super(const AsyncLoading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      state = const AsyncLoading();
      final courses = await repository.getCourses();
      state = AsyncData(courses);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  void toggleLiked(Course course) {
    state = state.whenData((courses) {
      return courses.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            title: c.title,
            category: c.category,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes + (c.liked ? -1 : 1),
            liked: !c.liked,
            image: c.image,
            saved: c.saved,
            subscribed: c.subscribed,
            price: c.price,
            chapters: c.chapters,
          );
        }
        return c;
      }).toList();
    });
  }

  void toggleSaved(Course course) {
    state = state.whenData((courses) {
      return courses.map((c) {
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
    state = state.whenData((courses) {
      return courses.map((c) {
        if (c == course) {
          return Course(
            id: c.id,
            title: c.title,
            category: c.category,
            topics: c.topics,
            saves: c.saves,
            likes: c.likes,
            liked: c.liked,
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
