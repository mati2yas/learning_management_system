import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/chapter_content/data_source/chapter_content_data_source.dart';
import 'package:lms_system/features/chapter_content/repository/cc_repository.dart';

final chapterContentRepositoryProvider =
    Provider<ChapterContentRepository>((ref) {
  return ChapterContentRepository(
    ref.watch(chapterContentDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});
