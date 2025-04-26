import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});
final connectivityStateProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.onConnectivityChanged;
});

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map((result) => !result.contains(ConnectivityResult.none));
  }

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    debugPrint("checking internet");
    try {
      final result = await InternetAddress.lookup('example.com');
      debugPrint("result of internet lookup: ${result.first.address}");
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
