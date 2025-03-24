import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/connectivity/connectivity_service.dart';
import 'package:lms_system/features/home/data_source/carousel_datasource.dart';

final carouselRepositoryProvider = Provider<CarouselRepository>(
  (ref) {
    return CarouselRepository(ref.watch(carouselDatasourceProvider),
        ref.watch(connectivityServiceProvider));
  },
);

class CarouselRepository {
  final CarouselDatasource _datasource;
  final ConnectivityService _connectivityService;

  CarouselRepository(this._datasource, this._connectivityService);

  Future<List<CarouselContent>> fetchCarouselContents() async {
    if (!await _connectivityService.hasConnection()) {
      throw Exception("No internet connection");
    }

    return await _datasource.getCarouselContents();
  }
}
