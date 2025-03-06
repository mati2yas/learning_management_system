import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/subscription/data_source/subscriptions/course_subscription_datasource.dart';

import '../model/course_subscription_model.dart';

final courseSubscriptionRepositoryProvider = Provider<CourseSubscriptionRepository>(
  (ref) => CourseSubscriptionRepository(
    ref.watch(subscriptionDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

class CourseSubscriptionRepository {
  final SubscriptionDataSource _dataSource;
  final ConnectivityService _connectivityService;

  CourseSubscriptionRepository(this._dataSource, this._connectivityService);

  Future<Response> subscribe(CourseSubscriptionModel request) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.subscribe(request);
  }
}
