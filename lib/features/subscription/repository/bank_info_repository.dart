import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/subscription/data_source/bank_info_datasource.dart';
import 'package:lms_system/features/subscription/model/bank_info.dart';

final bankInfoRepositoryProvider = Provider<BankInfoRepository>(
  (ref) {
    return BankInfoRepository(ref.watch(bankInfoDatasourceProvider),
        ref.watch(connectivityServiceProvider));
  },
);

class BankInfoRepository {
  final BankInfoDatasource _datasource;
  final ConnectivityService _connectivityService;

  BankInfoRepository(this._datasource, this._connectivityService);

  Future<List<BankInfo>> fetchBankInfo() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }

    return await _datasource.getBankInfos();
  }
}
