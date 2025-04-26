import 'package:flutter/material.dart';
import 'package:lms_system/features/shared/model/shared_course_model.dart';

class CourseRequestsDataSource {
  List<Course> fetchAddedCourses() {
    return [];
  }

  Future<List<Course>> fetchCoursesFromLocal() async {
    List<Course> courses = [];
    try {
      //courses = await SecureStorageService().getCoursesFromLocal();
    } catch (e) {
      debugPrint(e.toString());
    }
    return courses;
  }

  // Future<void> setCoursesToLocal(List<Course> courses) async {
  //   try {
  //     await SecureStorageService().saveCoursesToLocal(courses);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}
