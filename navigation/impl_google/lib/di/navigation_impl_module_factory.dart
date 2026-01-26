import 'package:core/di/core_module_factory.dart';
import 'package:navigation_core/repository/location_repository.dart';
import 'package:navigation_core/repository/route_repository.dart';
import 'package:navigation_impl/repository/google_route_repository.dart';
import 'package:navigation_impl/repository/platform_location_repository.dart';

class NavigationImplModuleFactory {
  static RouteRepository createRouteRepository() {
    return GoogleRouteRepository(CoreModuleFactory.createConfigRepository());
  }

  static LocationRepository createLocationRepository() {
    return PlatformLocationRepository();
  }
}
