import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/auth_status_registration/data_source/check_registered_data_source.dart';
import 'package:lms_system/features/auth_status_registration/repository/check_registration_repository.dart';

final registrationStatusDataSourceProvider = Provider((ref) {
  return RegistrationStatusDataSource(SecureStorageService());
});

final registrationStatusRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(registrationStatusDataSourceProvider);
  return RegistrationStatusRepository(dataSource);
});
