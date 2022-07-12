import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigation/coordinate_model.dart';

LatLng toLatLng(CoordinateModel coordinate) {
  return LatLng(coordinate.latitude, coordinate.longitude);
}
