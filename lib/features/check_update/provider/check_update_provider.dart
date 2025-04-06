import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lms_system/features/check_update/data_source/check_update_data_source.dart';
import 'package:lms_system/features/check_update/model/check_update_model.dart';

final appUpdateApiServiceProvider = Provider<AppUpdateApiService>((ref) {
  return AppUpdateApiService();
});

final appUpdateStatusProvider = FutureProvider<AppUpdateStatus>((ref) async {
  final service = ref.watch(appUpdateApiServiceProvider);
  return await service.fetchUpdateInfoFromBackend();
});

final updateNotifierProvider =
    StateNotifierProvider<UpdateNotifier, void>((ref) {
  return UpdateNotifier(ref);
});

class UpdateNotifier extends StateNotifier<void> {
  final Ref ref;

  UpdateNotifier(this.ref) : super(null);

  Future<void> checkForUpdates(BuildContext context) async {
    final updateInfo = await InAppUpdate.checkForUpdate();
    final backendInfo = await ref.read(appUpdateStatusProvider.future);

    final isCritical = backendInfo.latestVersion?.isCritical ?? false;

    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      if (isCritical && updateInfo.immediateUpdateAllowed) {
        final result = await InAppUpdate.performImmediateUpdate();
        _handleResult(context, result, forceRetry: true);
      } else if (!isCritical && updateInfo.flexibleUpdateAllowed) {
        final result = await InAppUpdate.startFlexibleUpdate();
        if (result == AppUpdateResult.success) {
          await InAppUpdate.completeFlexibleUpdate();
        }
        _handleResult(context, result);
      }
    }
  }

  void _handleResult(BuildContext context, AppUpdateResult result,
      {bool forceRetry = false}) {
    if (result == AppUpdateResult.success) {
      _showSnackbar(context, "Update successful!", type: "success");
    } else if (result == AppUpdateResult.userDeniedUpdate && forceRetry) {
      checkForUpdates(context); // Retry for critical updates
    } else if (result != AppUpdateResult.userDeniedUpdate) {
      _showSnackbar(context, "Update failed. Please try again.");
    }
  }

  void _showSnackbar(BuildContext context, String message, {String type = ""}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }
}
