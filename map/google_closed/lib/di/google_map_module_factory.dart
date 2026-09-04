import 'package:map_core/map_availability.dart';
import 'package:core/di/core_module_factory.dart';
import 'package:map_core/ui/map_initializer.dart';
import 'package:map_google/google_map_availability.dart';
import 'package:map_google/ui/google_map_initializer.dart';

class GoogleMapModuleFactory {
  static MapAvailability createMapAvailability() {
    return GoogleMapAvailability(CoreModuleFactory.createConfigRepository());
  }

  static MapInitializer? createMapInitializer() {
    return GoogleMapInitializer();
  }
}
