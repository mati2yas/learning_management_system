import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_urls.dart';
import 'package:lms_system/core/utils/dio_client.dart';
import 'package:lms_system/core/utils/error_handling.dart';
import 'package:lms_system/features/subscription/model/bank_info.dart';

final bankInfoDatasourceProvider = Provider<BankInfoDatasource>(
  (ref) => BankInfoDatasource(DioClient.instance),
);

class BankInfoDatasource {
  final Dio _dio;
  BankInfoDatasource(this._dio);

  Future<List<BankInfo>> getBankInfos() async {
    List<BankInfo> bankInfos = [];
    int? statusCode;

    try {
      await DioClient.setToken();
      final response = await _dio.get(AppUrls.bankAccounts);

      statusCode = response.statusCode;
      if (response.statusCode == 200) {
        for (var value in response.data) {
          BankInfo bankInfo = BankInfo.fromJson(value);
          bankInfos.add(bankInfo);
        }
      }
    } on DioException catch (e) {
      final errorMessage = ApiExceptions.getExceptionMessage(e, statusCode);
      throw Exception(errorMessage);
    }
    return bankInfos;
  }
}
