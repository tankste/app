import 'package:location_core/model/location_model.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';

abstract class LocationRepository {
  Future<LocationModel?> getCurrentLocation();

  Future<LocationModel?> getLastKnownLocation();

  double distanceBetween(CoordinateModel from, CoordinateModel to);

  Future<Result<bool, Exception>> requestPermission(bool force);
}
