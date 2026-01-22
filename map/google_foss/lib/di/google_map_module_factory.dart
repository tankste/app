import 'package:map_core/ui/map_initializer.dart';
import 'package:map_google/google_map_availability.dart';
import 'package:map_core/map_availability.dart';

class GoogleMapModuleFactory {
  static MapAvailability createMapAvailability() {
    return GoogleMapAvailability();
  }

  static MapInitializer? createMapInitializer() {
    return null;
  }
}
