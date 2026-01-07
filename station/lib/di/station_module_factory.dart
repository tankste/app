import 'package:station/repository/config_repository.dart';
import 'package:station/repository/currency_repository.dart';
import 'package:station/repository/marker_repository.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/origin_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/repository/price_snapshot_repository.dart';
import 'package:station/repository/station_repository.dart';
import 'package:core/di/core_module_factory.dart';

class StationModuleFactory {
  static MarkerRepository createMarkerRepository() {
    return TanksteWebMarkerRepository(
        createCurrencyRepository(), createConfigRepository());
  }

  static StationRepository createStationRepository() {
    return TanksteWebStationRepository(
        createCurrencyRepository(), createConfigRepository());
  }

  static PriceRepository createPriceRepository() {
    return TanksteWebPriceRepository(createConfigRepository());
  }

  static PriceSnapshotRepository createPriceSnapshotRepository() {
    return TanksteWebPriceSnapshotRepository(createConfigRepository());
  }

  static OpenTimeRepository createOpenTimeRepository() {
    return TanksteWebOpenTimeRepository(createConfigRepository());
  }

  static OriginRepository createOriginRepository() {
    return TanksteWebOriginRepository(createConfigRepository());
  }

  static CurrencyRepository createCurrencyRepository() {
    return LocalCurrencyRepository();
  }

  static ConfigRepository createConfigRepository() {
    return LocalConfigRepository(CoreModuleFactory.createConfigRepository());
  }
}
