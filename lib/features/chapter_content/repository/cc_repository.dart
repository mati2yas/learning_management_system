import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';

import '../data_source/chapter_content_data_source.dart';
import '../model/chapter_content_model.dart';

class ChapterContentRepository {
  final ChapterContentDataSource _dataSource;
  final ConnectivityService _connectivityService;

  ChapterContentRepository(this._dataSource, this._connectivityService);

  Future<ChapterContent> fetchChapterContent(String chapterId) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }

    return await _dataSource.fetchChapterContent(chapterId);
  }
}
