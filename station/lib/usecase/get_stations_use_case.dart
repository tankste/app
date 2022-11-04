import 'dart:math';

import 'package:navigation/coordinate_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';
import 'package:station/repository/station_repository.dart';
import 'package:station/station_model.dart';

abstract class GetStationsUseCase {
  Future<List<StationModel>> invoke(String type, CoordinateModel position);
}

class GetStationsUseCaseImpl extends GetStationsUseCase {
  final StationRepository _stationRepository;
  final DeveloperSettingsRepository _developerSettingsRepository;

  GetStationsUseCaseImpl(
      this._stationRepository, this._developerSettingsRepository);

  @override
  Future<List<StationModel>> invoke(
      String type, CoordinateModel position) async {
    List<StationPricesModel> minMaxPrices =
        await _fetchMinMaxPrices(type, position);
    StationPricesModel minPrices = minMaxPrices[0];
    StationPricesModel maxPrices = minMaxPrices[1];

    return _stationRepository.list(type, position, 15).then((stations) {
      return Future.wait(stations.map((station) async {
        return StationModel(
            station.id,
            station.name,
            station.company,
            station.address,
            StationPricesModel(
              station.prices.e5,
              await _getPriceRange(
                  minPrices.e5, maxPrices.e5, station.prices.e5),
              station.prices.e10,
              await _getPriceRange(
                  minPrices.e10, maxPrices.e10, station.prices.e10),
              station.prices.diesel,
              await _getPriceRange(
                  minPrices.diesel, maxPrices.diesel, station.prices.diesel),
            ),
            station.coordinate,
            station.openTimes,
            station.isOpen);
      }).toList());
    });
  }

  Future<List<StationPricesModel>> _fetchMinMaxPrices(
      String type, CoordinateModel position) {
    return _stationRepository.list(type, position, 25).then((stations) {
      Iterable<double> e5Prices =
          stations.map((s) => s.prices.e5).where((p) => p != 0.0);

      Iterable<double> e10Prices =
          stations.map((s) => s.prices.e10).where((p) => p != 0.0);

      Iterable<double> dieselPrices =
          stations.map((s) => s.prices.diesel).where((p) => p != 0.0);

      return [
        StationPricesModel(
            e5Prices.isNotEmpty ? e5Prices.reduce(min) : 0,
            StationPriceRange.unknown,
            e10Prices.isNotEmpty ? e10Prices.reduce(min) : 0,
            StationPriceRange.unknown,
            dieselPrices.isNotEmpty ? dieselPrices.reduce(min) : 0,
            StationPriceRange.unknown),
        StationPricesModel(
            e5Prices.isNotEmpty ? e5Prices.reduce(max) : 0,
            StationPriceRange.unknown,
            e10Prices.isNotEmpty ? e10Prices.reduce(max) : 0,
            StationPriceRange.unknown,
            dieselPrices.isNotEmpty ? dieselPrices.reduce(max) : 0,
            StationPriceRange.unknown),
      ];
    });
  }

  Future<StationPriceRange> _getPriceRange(
      double minPrice, double maxPrice, double price) {
    return _developerSettingsRepository.get().first.then((developerSettings) {
      if (developerSettings.isPercentagePriceRangesEnabled) {
        return _getPriceRangePercentage(minPrice, maxPrice, price);
      } else {
        return _getPriceRangeRelative(minPrice, price);
      }
    });
  }

  StationPriceRange _getPriceRangeRelative(double minPrice, double price) {
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

  StationPriceRange _getPriceRangePercentage(
      double minPrice, double maxPrice, double price) {
    if (price == 0.0) {
      return StationPriceRange.unknown;
    }

    if (minPrice + ((maxPrice - minPrice) * .1) >= price) {
      return StationPriceRange.cheap;
    } else if (minPrice + ((maxPrice - minPrice) * .5) >= price) {
      return StationPriceRange.normal;
    } else {
      return StationPriceRange.expensive;
    }
  }
}
