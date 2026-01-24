import 'package:map/map_models.dart';
import 'package:navigation/coordinate_model.dart';

LatLng toLatLng(CoordinateModel coordinate) {
  return LatLng(coordinate.latitude, coordinate.longitude);
}
