class Quiz {
  final int id;
  final String title;
  final int numberOfQuestions;
  final int duration;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.duration,
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
  final List<String> answers;

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

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? -1,
      quizId: json['quiz_id'] ?? -1,
      questionNumber: json['question_number'] ?? 0,
      text: json['text'] ?? "",
      isMultipleChoice: json['is_multiple_choice'] ?? false,
      imageUrl: json['question_image_url'],
      textExplanation: json['text_explanation'] ?? "",
      imageExplanationUrl: json['image_explanation_url'],
      videoExplanationUrl: json['video_explanation_url'],
      options: (json['options'] ?? []).cast<String>(),
      answers: (json['answer'] ?? []).cast<String>(),
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
    data['options'] = options;
    data['answer'] = answers;
    return data;
  }
}

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
