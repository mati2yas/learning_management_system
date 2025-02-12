import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/quiz/data_source/quiz_data_source.dart';
import 'package:lms_system/features/quiz/repository/quiz_repository.dart';

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  return QuizRepository(
    ref.watch(quizDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
