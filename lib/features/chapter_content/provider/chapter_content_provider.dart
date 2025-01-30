import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/chapter_content/model/chapter_content_model.dart';
import 'package:lms_system/features/chapter_content/provider/chapter_content_repository_provider.dart';
import 'package:lms_system/features/chapter_content/provider/current_chapter_id_provider.dart';
import 'package:lms_system/features/chapter_content/repository/cc_repository.dart';

final chapterContentNofierProvider = Provider((ref) {
  return ChapterContentNotifier(ref.watch(chapterContentRepositoryProvider));
});

final chapterContentProvider =
    AsyncNotifierProvider<ChapterContentNotifier, ChapterContent>(() {
  final container = ProviderContainer(overrides: [
    chapterContentRepositoryProvider,
    currentChapterIdProvider,
  ]);
  return container.read(chapterContentNofierProvider);
});

class ChapterContentNotifier extends AsyncNotifier<ChapterContent> {
  final ChapterContentRepository _repository;

  ChapterContentNotifier(this._repository);

  @override
  Future<ChapterContent> build() async {
    return fetchChapterContent();
  }

  Future<ChapterContent> fetchChapterContent() async {
    final chapterId = ref.read(currentChapterIdProvider);
    state = const AsyncValue.loading();
    try {
      final chapterContent = await _repository.fetchChapterContent(chapterId);
      state = AsyncData(chapterContent);
      return chapterContent;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
