import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/subscription/model/exam_subscription_model.dart';

import '../data_source/subscriptions/exam_subscription_datasource.dart'
    show ExamSubscriptionDataSource, examSubscriptionDataSourceProvider;

final examsSubscriptionRepositoryProvider =
    Provider<ExamsSubscriptionRepository>(
  (ref) => ExamsSubscriptionRepository(
    ref.watch(examSubscriptionDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  ),
);

class ExamsSubscriptionRepository {
  final ExamSubscriptionDataSource _dataSource;
  final ConnectivityService _connectivityService;

  ExamsSubscriptionRepository(this._dataSource, this._connectivityService);

  Future<Response> subscribe(ExamSubscriptionModel request) async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No Internet");
    }
    return await _dataSource.subscribe(request);
  }
}
