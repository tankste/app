import 'package:navigation_core/model/coordinate_model.dart';

abstract class LocationRepository {
  Future<CoordinateModel?> getCurrentLocation();
}
