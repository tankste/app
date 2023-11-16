import 'package:station/repository/marker_repository.dart';
import 'package:station/repository/open_time_repository.dart';
import 'package:station/repository/price_repository.dart';
import 'package:station/repository/station_repository.dart';

class StationModuleFactory {
  static MarkerRepository createMarkerRepository() {
    return TanksteWebMarkerRepository();
  }

  static StationRepository createStationRepository() {
    return TanksteWebStationRepository();
  }

  static PriceRepository createPriceRepository() {
    return TanksteWebPriceRepository();
  }

  static OpenTimeRepository createOpenTimeRepository() {
    return TanksteWebOpenTimeRepository();
  }
}
