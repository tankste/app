import 'package:navigation_core/model/coordinate_model.dart';

class RouteModel {
  final int distanceMeters;
  final int travelTimeSeconds;
  final List<CoordinateModel> routeCoordinates;

  RouteModel({
      required this.distanceMeters, required this.travelTimeSeconds, required this.routeCoordinates});
}
