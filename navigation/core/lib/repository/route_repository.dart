import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/model/route_model.dart';

abstract class RouteRepository {
  Future<Result<RouteModel, Exception>> getRoutePreview(CoordinateModel from, CoordinateModel to);
}
