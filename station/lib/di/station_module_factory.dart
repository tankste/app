import 'package:station/repository/marker_repository.dart';

class StationModuleFactory {
  static MarkerRepository createSessionRepository() {
    return TanksteWebMarkerRepository();
  }
}
