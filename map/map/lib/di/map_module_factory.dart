import 'package:map/repository/camera_position_repository.dart';
import 'package:map/repository/map_provider_repository.dart';
import 'package:map_apple/di/apple_map_module_factory.dart';
import 'package:map_google/di/google_map_module_factory.dart';

class MapModuleFactory {
  static MapProviderRepository createMapProviderRepository() {
    return LocalMapProviderRepository(
        GoogleMapModuleFactory.createMapAvailability(),
        AppleMapModuleFactory.createMapAvailability());
  }

  static CameraPositionRepository createCameraPositionRepository() {
    return LocalCameraPositionRepository();
  }
}
