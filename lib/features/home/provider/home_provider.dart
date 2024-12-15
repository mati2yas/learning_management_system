import 'package:lms_system/features/home/data_source/home_data_source.dart';
import 'package:riverpod/riverpod.dart';

import '../../shared_course/model/shared_course_model.dart';
import '../../shared_course/model/shared_user.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  return HomeDataSource();
});

final homeProvider = StateNotifierProvider<HomeNotifier, List<Course>>((ref) {
  final dataSource = ref.read(homeDataSourceProvider);
  return HomeNotifier(dataSource);
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

class HomeNotifier extends StateNotifier<List<Course>> {
  final HomeDataSource dataSource;
  HomeNotifier(this.dataSource) : super([]) {
    loadData();
  }

  void loadData() {
    state = dataSource.fetchCourses();
  }

  void toggleLiked(Course course) {
    state = state.map((c) {
      if (c == course) {
        return Course(
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves + (c.saved ? -1 : 1),
          liked: c.liked,
          likes: c.likes + (c.liked ? -1 : 1),
          image: c.image,
          saved: !c.saved,
          subscribed: c.subscribed,
          chapters: c.chapters,
        );
      }
      return c;
    }).toList();
  }

  void toggleSaved(Course course) {
    state = state.map((c) {
      if (c == course) {
        return Course(
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves + (c.saved ? -1 : 1),
          liked: c.liked,
          likes: c.likes,
          image: c.image,
          saved: !c.saved,
          subscribed: c.subscribed,
          chapters: c.chapters,
        );
      }
      return c;
    }).toList();
  }

  void toggleSubscribed(Course course) {
    state = state.map((c) {
      if (c == course) {
        return Course(
          title: c.title,
          desc: c.desc,
          topics: c.topics,
          saves: c.saves,
          likes: c.likes,
          liked: c.liked,
          image: c.image,
          saved: c.saved,
          subscribed: !c.subscribed,
          chapters: c.chapters,
        );
      }
      return c;
    }).toList();
  }
}
