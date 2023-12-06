import 'package:navigation/coordinate_model.dart';
import 'package:navigation/repository/location_repository.dart';
import 'package:navigation/repository/route_repository.dart';
import 'package:navigation/route_model.dart';

abstract class GetRoutePreviewUseCase {

  Future<RouteModel> invoke(CoordinateModel target);
}

class GetRoutePreviewUseCaseImpl extends GetRoutePreviewUseCase {

  final LocationRepository locationRepository;
  final RouteRepository routeRepository;

  GetRoutePreviewUseCaseImpl(this.locationRepository, this.routeRepository);

  @override
  Future<RouteModel> invoke(CoordinateModel target) async {
    CoordinateModel? from = await locationRepository.getCurrentLocation();
    if (from == null) {
      throw Exception("Unable to get current location.");
    }

    return await routeRepository.getRoutePreview(from, target);
  }
}