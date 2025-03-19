class PaidExam {
  final int examId;
  final String examType;
  final String parentCourseTitle;
  final int parentCourseId;
  final String examYear;
  final int duration;
  PaidExam({
    required this.examId,
    required this.examYear,
    required this.examType,
    required this.parentCourseTitle,
    required this.parentCourseId,
    required this.duration,
  });

  factory PaidExam.fromJson(Map<String, dynamic> json) {
    return PaidExam(
      examId: json["exam_id"] ?? -1,
      examYear: json["exam_year"] ?? "Year Unknown",
      examType: json["exam_type"] ?? "Type Unknown",
      parentCourseTitle: json["parent_course_title"] ?? "Parent Course Unknown",
      parentCourseId: json["parent_course_id"] ?? 0,
      duration: json["exam_duration"],
    );
  }
}
