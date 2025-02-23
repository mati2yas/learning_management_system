import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/features/home/repository/home_repository.dart';
import 'package:lms_system/features/paid_courses/repository/paid_courses_repository.dart';
import 'package:lms_system/features/shared/model/api_response_model.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

final paidCoursesApiNotifierProvider = Provider(
    (ref) => PaidCoursesNotifier(ref.read(paidCoursesRepositoryProvider)));

final paidCoursesApiProvider =
    AsyncNotifierProvider<PaidCoursesNotifier, List<Course>>(
  () {
    final container = ProviderContainer(
      overrides: [
        homeRepositoryProvider,
      ],
    );
    return container.read(paidCoursesApiNotifierProvider);
  },
);

class PaidCoursesNotifier extends AsyncNotifier<List<Course>> {
  final PaidCoursesRepository _repository;

  PaidCoursesNotifier(this._repository);

  @override
  Future<List<Course>> build() async {
    // Fetch and return the initial data
    return fetchPaidCourses();
  }

  Future<List<Course>> fetchPaidCourses() async {
    try {
      final courses = await _repository.fetchPaidCourses();
      return courses; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }

  Future<ApiResponse> toggleLiked(Course course) async {
    await DioClient.setToken();
    String responseMessage = "";
    bool responseStatus = false;
    try {
      final response = await _repository.toggleCourseLiked(course);
      if (response.statusCode == 200) {
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
      (responseMessage, responseStatus) =
          (response.data["message"] ?? "Ok", response.data["status"] ?? true);
    } on Exception catch (error, stack) {
      state = AsyncError(error, stack);

      (responseMessage, responseStatus) = (error.toString(), false);
    }
    return ApiResponse(
        message: responseMessage, responseStatus: responseStatus);
  }

  Future<ApiResponse> toggleSaved(Course course) async {
    await DioClient.setToken();
    String responseMessage = "";
    bool responseStatus = false;
    try {
      final response = await _repository.toggleCourseSaved(course);
      if (response.statusCode == 200) {
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
    } on Exception catch (error, stack) {
      state = AsyncError(error, stack);

      (responseMessage, responseStatus) = (error.toString(), false);
    }
    return ApiResponse(
        message: responseMessage, responseStatus: responseStatus);
  }
}
