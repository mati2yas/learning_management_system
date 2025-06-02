import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/storage_service.dart';
import 'package:lms_system/features/home/data_source/carousel_datasource.dart';
import 'package:lms_system/features/home/repository/carousel_repository.dart';

final carouselApiProvider =
    AsyncNotifierProvider<CarouselNotifier, List<CarouselContent>>(
  () {
    final container = ProviderContainer(
      overrides: [carouselRepositoryProvider],
    );
    return container.read(carouselNotifierProvider);
  },
);

final carouselNotifierProvider =
    Provider((ref) => CarouselNotifier(ref.read(carouselRepositoryProvider)));

class CarouselNotifier extends AsyncNotifier<List<CarouselContent>> {
  final CarouselRepository _repository;

  CarouselNotifier(this._repository);

  @override
  Future<List<CarouselContent>> build() async {
    // Fetch and return the initial data
    var usr = await SecureStorageService().getUserFromStorage();
    //debugPrint("token: ${usr?.token}");
    return fetchCarouselData();
  }

  Future<List<CarouselContent>> fetchCarouselData() async {
    try {
      final carousels = await _repository.fetchCarouselContents();
      return carousels; // Automatically updates the state
    } catch (e, stack) {
      debugPrint(e.toString());
      // Set error state and rethrow
      state = AsyncError(e, stack);
      rethrow;
    }
  }
}
