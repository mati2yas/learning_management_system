class Quiz {
  final int id;
  final String title;
  final int numberOfQuestions;
  int? duration;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.title,
    this.duration,
    required this.numberOfQuestions,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    var questions = <QuizQuestion>[];
    if (json["questions"] != null) {
      json['questions'].forEach((v) {
        questions.add(QuizQuestion.fromJson(v));
      });
    }
    return Quiz(
      id: json['id'] ?? -1,
      duration: json["quiz_duration"],
      title: json['title'] ?? "No Title",
      numberOfQuestions: json['number_of_questions'] ?? 0,
      questions: questions,
    );
  }

  factory Quiz.initial() {
    return Quiz(
      id: -1,
      title: "",
      numberOfQuestions: 0,
      duration: 10,
      questions: [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['number_of_questions'] = numberOfQuestions;
    data['questions'] = questions.map((v) => v.toJson()).toList();
    return data;
  }
}

class QuizQuestion {
  int id;
  int quizId;
  int questionNumber;
  String text;
  bool isMultipleChoice;
  String? imageUrl;
  String textExplanation;
  String? imageExplanationUrl;
  String? videoExplanationUrl;
  final List<String> options;
  final List<String> answers; // This will now store unique, stripped, lowercase answers

  QuizQuestion({
    required this.id,
    required this.quizId,
    required this.questionNumber,
    required this.text,
    required this.isMultipleChoice,
    this.imageUrl,
    required this.textExplanation,
    this.imageExplanationUrl,
    this.videoExplanationUrl,
    required this.options,
    required this.answers,
  });

  // Helper function to strip prefixes AND convert to lowercase
  static String _normalizeTextForComparison(String text) {
    // Regular expression to find a letter followed by a dot and optional space (e.g., "A. ", "b. ")
    final RegExp prefixPattern = RegExp(r'^[a-zA-Z]\.\s*');
    String processedText = text;

    // 1. Strip prefix
    if (prefixPattern.hasMatch(processedText)) {
      processedText = processedText.replaceFirst(prefixPattern, '').trim();
    }

    // 2. Convert to lowercase for consistent comparison
    return processedText.toLowerCase();
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Normalize options: strip prefixes and convert to lowercase
    List<String> rawOptions = (json['options'] as List?)?.cast<String>() ?? [];
    List<String> normalizedOptions = rawOptions.map((op) => _normalizeTextForComparison(op)).toList();

    // Normalize answers: strip prefixes, convert to lowercase, AND remove duplicates
    List<String> rawAnswers = (json['answer'] as List?)?.cast<String>() ?? [];
    List<String> processedAnswersWithDuplicates = rawAnswers.map((ans) => _normalizeTextForComparison(ans)).toList();
    List<String> uniqueNormalizedAnswers = processedAnswersWithDuplicates.toSet().toList(); // Remove duplicates here

    return QuizQuestion(
      id: json['id'] ?? -1,
      quizId: json['quiz_id'] ?? -1,
      questionNumber: json['question_number'] ?? 0,
      text: json['text'] ?? "", // Keep original casing for display if preferred
      isMultipleChoice: json['is_multiple_choice'] ?? false,
      imageUrl: json['question_image_url'],
      textExplanation: json['text_explanation'] ?? "", // Keep original casing for display
      imageExplanationUrl: json['image_explanation_url'],
      videoExplanationUrl: json['video_explanation_url'],
      options: normalizedOptions, // Use the normalized options
      answers: uniqueNormalizedAnswers, // Use the unique and normalized answers
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_id'] = quizId;
    data['question_number'] = questionNumber;
    data['text'] = text;
    data['is_multiple_choice'] = isMultipleChoice;
    data['question_image_url'] = imageUrl;
    data['text_explanation'] = textExplanation;
    data['image_explanation_url'] = imageExplanationUrl;
    data['video_explanation_url'] = videoExplanationUrl;
    // When converting back to JSON, you might want to send the raw data
    // or the normalized data depending on your backend's expectations.
    // For now, it sends the internal (normalized) options/answers.
    data['options'] = options;
    data['answer'] = answers;
    return data;
  }
}
// class QuizQuestion {
//   int id;
//   int quizId;
//   int questionNumber;
//   String text;
//   bool isMultipleChoice;
//   String? imageUrl;
//   String textExplanation;
//   String? imageExplanationUrl;
//   String? videoExplanationUrl;
//   final List<String> options;
//   final List<String> answers;

//   QuizQuestion({
//     required this.id,
//     required this.quizId,
//     required this.questionNumber,
//     required this.text,
//     required this.isMultipleChoice,
//     this.imageUrl,
//     required this.textExplanation,
//     this.imageExplanationUrl,
//     this.videoExplanationUrl,
//     required this.options,
//     required this.answers,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       id: json['id'] ?? -1,
//       quizId: json['quiz_id'] ?? -1,
//       questionNumber: json['question_number'] ?? 0,
//       text: json['text'] ?? "",
//       isMultipleChoice: json['is_multiple_choice'] ?? false,
//       imageUrl: json['question_image_url'],
//       textExplanation: json['text_explanation'] ?? "",
//       imageExplanationUrl: json['image_explanation_url'],
//       videoExplanationUrl: json['video_explanation_url'],
//       options: (json['options'] ?? []).cast<String>(),
//       answers: (json['answer'] ?? []).cast<String>(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['quiz_id'] = quizId;
//     data['question_number'] = questionNumber;
//     data['text'] = text;
//     data['is_multiple_choice'] = isMultipleChoice;
//     data['question_image_url'] = imageUrl;
//     data['text_explanation'] = textExplanation;
//     data['image_explanation_url'] = imageExplanationUrl;
//     data['video_explanation_url'] = videoExplanationUrl;
//     data['options'] = options;
//     data['answer'] = answers;
//     return data;
//   }
// }

class QuizScore {
  int quizId;
  int score;
  QuizScore({
    required this.quizId,
    required this.score,
  });

  factory QuizScore.fromJson(Map<String, dynamic> json) {
    return QuizScore(
      quizId: json["quiz_id"],
      score: json["score"],
    );
  }
  factory QuizScore.initial() {
    return QuizScore(quizId: -1, score: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "quiz_id": quizId,
      "score": score,
    };
  }
}
