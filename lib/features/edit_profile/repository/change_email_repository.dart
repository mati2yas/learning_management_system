import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/edit_profile/data_source/change_email_datasource.dart';
import 'package:lms_system/features/edit_profile/presentation/screens/change_email_screen.dart';
import 'package:lms_system/features/edit_profile/provider/change_email_provider.dart';

final changeEmailRepositoryProvider = Provider<ChangeEmailRepository>((ref) {
  return ChangeEmailRepository(
    ref.watch(changeEmailDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
});

class ChangeEmailRepository {
  final ChangeEmailDataSource _dataSource;
  final ConnectivityService _connectivityService;

  ChangeEmailRepository(this._dataSource, this._connectivityService);

  Future<Response?> changeEmail({required String email}) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }
    return await _dataSource.changeEmail(
      email: email,
    );
  }
  
}
