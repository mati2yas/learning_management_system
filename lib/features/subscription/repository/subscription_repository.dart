import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/subscription/data_source/subscription_data_source.dart';
import 'package:lms_system/features/subscription/model/subscription_model.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => SubscriptionRepository(
    ref.watch(subscriptionDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

class SubscriptionRepository {
  final SubscriptionDataSource _dataSource;
  final ConnectivityService _connectivityService;

  SubscriptionRepository(this._dataSource, this._connectivityService);

  
  Future<Response> subscribe(SubscriptionModel request) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.subscribe(request);
  }
}
