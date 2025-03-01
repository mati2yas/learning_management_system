import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

class CurrentUserDataSource {
  final SecureStorageService _storageService;

  CurrentUserDataSource(this._storageService);
  Future<User> getUser() async {
    final user = await _storageService.getUserFromStorage();
    if (user != null) {
      return user;
    } else {
      return User(
        name: "No name",
        email: "no email",
        password: "",
      );
    }
  }
}
