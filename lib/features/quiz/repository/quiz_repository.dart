import '../../../core/utils/connectivity/connectivity_service.dart';
import '../data_source/quiz_data_source.dart';
import '../model/quiz_model.dart';

class QuizRepository {
  final QuizDataSource _dataSource;
  final ConnectivityService _connectivityService;

  QuizRepository(this._dataSource, this._connectivityService);

  Future<Quiz> fetchQuizData(String quizId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }

    return await _dataSource.fetchQuizData(quizId);
  }
}
