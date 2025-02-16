import 'package:lms_system/core/utils/storage_service.dart';

class RegistrationStatusDataSource {
  final SecureStorageService _storageService;

  RegistrationStatusDataSource(this._storageService);

  Future<void> clearRegistrationStatus() async {
    await _storageService.deleteUser(); // Assuming the user has an id of 1
  }

  Future<bool> isUserRegistered() async {
    final user = await _storageService.getUserFromStorage();
    return user != null;
  }
}
