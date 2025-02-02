import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/auth_status_registration/provider/registration_status_controller.dart';
import 'package:lms_system/features/shared/model/shared_user.dart';

import '../repository/check_registration_repository.dart';

final registrationStatusControllerProvider =
    StateNotifierProvider<RegistrationStatusController, bool>((ref) {
  final repository = ref.watch(registrationStatusRepositoryProvider);
  return RegistrationStatusController(repository);
});

class RegistrationStatusController extends StateNotifier<bool> {
  final RegistrationStatusRepository _repository;

  RegistrationStatusController(this._repository) : super(false);

  Future<bool> checkRegistrationStatus() async {
    state = await _repository.isUserRegistered();
    return state;
  }

  

  Future<void> clearStatus() async {
    await _repository.clearRegistrationStatus();
    state = false; // Reset state
  }
}
