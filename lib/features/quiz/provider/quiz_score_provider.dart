// import 'dart:convert';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lms_system/features/quiz/model/quiz_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final quizScoreControllerProvider =
//     StateNotifierProvider<quizScoreController, List<QuizScore>>(
//   (ref) => quizScoreController(),
// );

// class quizScoreController extends StateNotifier<List<QuizScore>> {
//   quizScoreController() : super([]);

//   Future<void> addQuizScore(QuizScore qScore) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String, dynamic>  
//     state = [...state, qScore];
//     for (var score in state) {
//       var json = jsonDecode(score);
//       quizScores.add(QuizScore.fromJson(json));
//     }
//   }

//   Future<void> getScoreByQuizId(String quizId) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> scores = prefs.getStringList("quizScores") ?? [];
   
//     List<QuizScore> quizScores = [];
//     for (var score in scores) {
//       var json = jsonDecode(score);
//       quizScores.add(QuizScore.fromJson(json));
//     }
//     for (var qScore in quizScores) {
//       if (qScore.quizId == quizId) {
//         state = qScore;
//         return;
//       }
//     }
//     state = QuizScore.initial();
//   }

//   Future<void> loginUser() async {
//     try {} catch (e) {
//       rethrow;
//     }
//   }

  
// }
