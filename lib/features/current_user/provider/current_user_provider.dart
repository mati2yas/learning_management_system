import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/db_service.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/current_user/data_source/current_user_data_source.dart';
import 'package:lms_system/features/current_user/repository/current_user_repository.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

final currentUserDataSourceProvider = Provider((ref) {
  return CurrentUserDataSource(SecureStorageService());
});

final currentUserNotifierProvider = Provider(
    (ref) => CurrentUserNotifier(ref.read(currentUserRepositoryProvider)));

final currentUserProvider = AsyncNotifierProvider<CurrentUserNotifier, User>(
  () {
    final container = ProviderContainer(
      overrides: [
        currentUserRepositoryProvider,
      ],
    );
    return container.read(currentUserNotifierProvider);
  },
);

final currentUserRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(currentUserDataSourceProvider);
  return CurrentUserRepository(dataSource);
});

class CurrentUserNotifier extends AsyncNotifier<User> {
  final CurrentUserRepository _repository;
  CurrentUserNotifier(this._repository);

  @override
  Future<User> build() async {
    return getUser();
  }

  Future<User> getUser() async {
    return await _repository.getUser();
  }
}
