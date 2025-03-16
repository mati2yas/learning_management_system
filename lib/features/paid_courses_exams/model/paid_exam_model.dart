class PaidExam {
  final int examId;
  final String examType;
  final String examYear;
  PaidExam({
    required this.examId,
    required this.examYear,
    required this.examType,
  });

  factory PaidExam.fromJson(Map<String, dynamic> json) {
    return PaidExam(
      examId: json["exam_id"] ?? -1,
      examYear: json["exam_year"] ?? "Year Unknown",
      examType: json["exam_type"] ?? "Type Unknown",
    );
  }
}
