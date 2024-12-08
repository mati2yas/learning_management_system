import 'package:lms_system/features/shared_course/model/shared_course_model.dart';

enum CategoryType { lowerGrade, highSchool, university, random }

class CourseCategory {
  final String id;
  final String name;
  final CategoryType categoryType;
  final List<Grade> grades;

  CourseCategory({
    required this.id,
    required this.name,
    required this.grades,
    required this.categoryType,
  });
}

class Grade {
  final String id;
  final String name;
  final List<SubCategory>? subCategories; // Optional subcategories
  final List<Course> courses; // Courses directly under this grade

  Grade({
    required this.id,
    required this.name,
    this.subCategories,
    this.courses = const [],
  });
}

class SubCategory {
  final String id;
  final String name;
  final List<Course> courses;

  SubCategory({
    required this.id,
    required this.name,
    this.courses = const [],
  });
}