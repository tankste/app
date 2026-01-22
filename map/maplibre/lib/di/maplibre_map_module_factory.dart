import 'package:core/di/core_module_factory.dart';
import 'package:map_core/map_availability.dart';
import 'package:map_core/ui/map_initializer.dart';
import 'package:map_maplibre/maplibre_map_availability.dart';

class MapLibreMapModuleFactory {
  static MapAvailability createMapAvailability() {
    return MapLibreMapAvailability(CoreModuleFactory.createConfigRepository());
  }

  static MapInitializer? createMapInitializer() {
    return null;
  }
}
