import 'package:location_core/repository/location_permission_repository.dart';
import 'package:location_core/repository/location_repository.dart';
import 'package:location_impl/repository/platform_location_repository.dart';

class LocationImplModuleFactory {
  static LocationRepository createLocationRepository() {
    return PlatformLocationRepository(createLocationPermissionRepository());
  }

  static LocationPermissionRepository createLocationPermissionRepository() {
    return LocalLocationPermissionRepository();
  }
}