import 'package:navigation_core/repository/location_repository.dart';
import 'package:navigation_core/repository/route_repository.dart';
import 'package:navigation_impl/repository/foss_route_repository.dart';
import 'package:navigation_impl/repository/platform_location_repository.dart';

class NavigationImplModuleFactory {
  static RouteRepository createRouteRepository() {
    return FossRouteRepository();
  }

  static LocationRepository createLocationRepository() {
    return PlatformLocationRepository();
  }
}
