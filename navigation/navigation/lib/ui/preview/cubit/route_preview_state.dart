import 'package:navigation_core/model/coordinate_model.dart';

abstract class RoutePreviewState {
  CoordinateModel target;

  RoutePreviewState({required this.target});
}

class LoadingRoutePreviewState extends RoutePreviewState {
  LoadingRoutePreviewState({required super.target});
}

class NoRouteRoutePreviewState extends RoutePreviewState {
  NoRouteRoutePreviewState({required super.target});
}

class RouteRoutePreviewState extends RoutePreviewState {
  final String distance;
  final String time;
  final List<CoordinateModel> coordinates;

  RouteRoutePreviewState(
      {required this.distance,
      required this.time,
      required this.coordinates,
      required super.target});
}
