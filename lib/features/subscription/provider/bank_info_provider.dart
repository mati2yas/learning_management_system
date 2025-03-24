import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/features/subscription/model/bank_info.dart';
import 'package:lms_system/features/subscription/repository/bank_info_repository.dart';

final bankInfoApiProvider =
    AsyncNotifierProvider<BankInfoNotifier, List<BankInfo>>(
  () {
    final container = ProviderContainer(
      overrides: [bankInfoRepositoryProvider],
    );
    return container.read(bankInfoNotifierProvider);
  },
);

final bankInfoNotifierProvider =
    Provider((ref) => BankInfoNotifier(ref.read(bankInfoRepositoryProvider)));

class BankInfoNotifier extends AsyncNotifier<List<BankInfo>> {
  final BankInfoRepository _repository;

  BankInfoNotifier(this._repository);

  @override
  Future<List<BankInfo>> build() async {
    // Fetch and return the initial data
    return fetchBankInfo();
  }

  Future<List<BankInfo>> fetchBankInfo() async {
    try {
      final BankInfos = await _repository.fetchBankInfo();
      return BankInfos; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}

class BankInfoRepositoryProvider {}
