import 'package:location/location.dart';
import 'package:location_core/repository/location_permission_repository.dart';
import 'package:location_impl/di/location_impl_module_factory.dart';

class LocationModuleFactory {
  static LocationRepository createLocationRepository() {
    return LocationImplModuleFactory.createLocationRepository();
  }
  static LocationPermissionRepository createLocationPermissionRepository() {
    return LocationImplModuleFactory.createLocationPermissionRepository();
  }
}
