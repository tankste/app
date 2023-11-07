import 'package:map/ui/generic/generic_map.dart';
import 'package:navigation/coordinate_model.dart';

LatLng toLatLng(CoordinateModel coordinate) {
  return LatLng(coordinate.latitude, coordinate.longitude);
}
