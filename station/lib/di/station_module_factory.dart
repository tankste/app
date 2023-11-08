import 'package:station/repository/marker_repository.dart';
import 'package:station/repository/station_repository.dart';

class StationModuleFactory {
  static MarkerRepository createMarkerRepository() {
    return TanksteWebMarkerRepository();
  }
  static StationRepository createStationRepository() {
    return TanksteWebStationRepository();
  }
}
