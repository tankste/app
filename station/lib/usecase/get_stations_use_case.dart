import 'dart:math';

import 'package:navigation/coordinate_model.dart';
import 'package:station/repository/station_repository.dart';
import 'package:station/station_model.dart';

abstract class GetStationsUseCase {
  Future<List<StationModel>> invoke(String type, CoordinateModel position);
}

class GetStationsUseCaseImpl extends GetStationsUseCase {
  final StationRepository _stationRepository;

  GetStationsUseCaseImpl(this._stationRepository);

  @override
  Future<List<StationModel>> invoke(
      String type, CoordinateModel position) async {
    StationPricesModel minPrices = await _fetchMinPrices(type, position);

    return _stationRepository.list(type, position, 15).then((stations) {
      return stations
          .map((station) => StationModel(
              station.id,
              station.name,
              station.company,
              station.address,
              StationPricesModel(
                station.prices.e5,
                _getPriceRange(minPrices.e5, station.prices.e5),
                station.prices.e10,
                _getPriceRange(minPrices.e10, station.prices.e10),
                station.prices.diesel,
                _getPriceRange(minPrices.diesel, station.prices.diesel),
              ),
              station.coordinate,
              station.openTimes,
              station.isOpen))
          .toList();
    });
  }

  Future<StationPricesModel> _fetchMinPrices(
      String type, CoordinateModel position) {
    return _stationRepository.list(type, position, 25).then((stations) {
      Iterable<double> e5Prices =
          stations.map((s) => s.prices.e5).where((p) => p != 0.0);

      Iterable<double> e10Prices =
          stations.map((s) => s.prices.e10).where((p) => p != 0.0);

      Iterable<double> dieselPrices =
          stations.map((s) => s.prices.diesel).where((p) => p != 0.0);
      print("e5Prices: $e5Prices");
      print("e10Prices: $e10Prices");
      print("dieselPrices: $dieselPrices");
      return StationPricesModel(
          e5Prices.isNotEmpty ? e5Prices.reduce(min) : 0,
          StationPriceRange.unknown,
          e10Prices.isNotEmpty ? e10Prices.reduce(min) : 0,
          StationPriceRange.unknown,
          dieselPrices.isNotEmpty ? dieselPrices.reduce(min) : 0,
          StationPriceRange.unknown);
    });
  }

  StationPriceRange _getPriceRange(double minPrice, double price) {
    if (price == 0.0) {
      return StationPriceRange.unknown;
    }

    if (minPrice + 0.04 >= price) {
      return StationPriceRange.cheap;
    } else if (minPrice + 0.10 >= price) {
      return StationPriceRange.normal;
    } else {
      return StationPriceRange.expensive;
    }
  }
}
