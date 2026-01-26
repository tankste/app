import 'package:core/config/config_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/model/route_model.dart';
import 'package:navigation_core/repository/route_repository.dart';

class FossRouteRepository extends RouteRepository {
  FossRouteRepository();

  @override
  Future<Result<RouteModel, Exception>> getRoutePreview(
      CoordinateModel from, CoordinateModel to) {
    return Future.value(
        Result.error(Exception("Route is currently not supported.")));
  }
}
