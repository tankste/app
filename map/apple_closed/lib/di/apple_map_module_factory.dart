import 'package:map_apple/apple_map_availability.dart';
import 'package:map_core/map_availability.dart';
import 'package:map_core/ui/map_initializer.dart';

class AppleMapModuleFactory {
  static MapAvailability createMapAvailability() {
    return AppleMapAvailability();
  }

  static MapInitializer? createMapInitializer() {
    return null;
  }
}
