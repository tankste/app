import 'package:station/repository/config_repository.dart';
import 'package:station/repository/marker_repository.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/repository/station_repository.dart';
import 'package:core/di/core_module_factory.dart';

class StationModuleFactory {
  static MarkerRepository createMarkerRepository() {
    return TanksteWebMarkerRepository(createConfigRepository());
  }

  static StationRepository createStationRepository() {
    return TanksteWebStationRepository(createConfigRepository());
  }

  static PriceRepository createPriceRepository() {
    return TanksteWebPriceRepository(createConfigRepository());
  }

  static OpenTimeRepository createOpenTimeRepository() {
    return TanksteWebOpenTimeRepository(createConfigRepository());
  }

  static ConfigRepository createConfigRepository() {
    return LocalConfigRepository(CoreModuleFactory.createConfigRepository());
  }
}
