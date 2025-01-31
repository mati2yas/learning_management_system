class Questions {
  int? id;
  int? quizId;
  int? questionNumber;
  String? text;
  Null isMultipleChoice;
  Null questionImageUrl;
  String? textExplanation;
  Null imageExplanationUrl;
  String? videoExplanationUrl;
  List<String>? options;
  List<String>? answer;
  String? createdAt;
  String? updatedAt;

  Questions(
      {this.id,
      this.quizId,
      this.questionNumber,
      this.text,
      this.isMultipleChoice,
      this.questionImageUrl,
      this.textExplanation,
      this.imageExplanationUrl,
      this.videoExplanationUrl,
      this.options,
      this.answer,
      this.createdAt,
      this.updatedAt});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quizId = json['quiz_id'];
    questionNumber = json['question_number'];
    text = json['text'];
    isMultipleChoice = json['is_multiple_choice'];
    questionImageUrl = json['question_image_url'];
    textExplanation = json['text_explanation'];
    imageExplanationUrl = json['image_explanation_url'];
    videoExplanationUrl = json['video_explanation_url'];
    options = json['options'].cast<String>();
    answer = json['answer'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['quiz_id'] = quizId;
    data['question_number'] = questionNumber;
    data['text'] = text;
    data['is_multiple_choice'] = isMultipleChoice;
    data['question_image_url'] = questionImageUrl;
    data['text_explanation'] = textExplanation;
    data['image_explanation_url'] = imageExplanationUrl;
    data['video_explanation_url'] = videoExplanationUrl;
    data['options'] = options;
    data['answer'] = answer;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Quiz {
  int? id;
  String? title;
  int? numberOfQuestions;
  List<Questions>? questions;

  Quiz({this.id, this.title, this.numberOfQuestions, this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    numberOfQuestions = json['number_of_questions'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['number_of_questions'] = numberOfQuestions;
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
