import 'package:lms_system/features/shared/model/exam_and_quiz/answers_holder.dart';
import 'package:lms_system/features/shared/model/exam_and_quiz/score_value.dart';

class ScoreManagement {
  final List<AnswersHolder> answersHolders;
  final ScoreValue scoreValue;

  ScoreManagement({
    required this.answersHolders,
    required this.scoreValue,
  });
  ScoreManagement copyWith({
    List<AnswersHolder>? answersHolders,
    ScoreValue? scoreValue,
  }) {
    return ScoreManagement(
      answersHolders: answersHolders ?? this.answersHolders,
      scoreValue: scoreValue ?? this.scoreValue,
    );
  }

  factory ScoreManagement.initial() {
    return ScoreManagement(
      answersHolders: [],
      scoreValue: const ScoreValue(
        attemptedQuestions: 0,
        totalQuestions: 0,
        score: 0,
      ),
    );
  }
}
