import 'package:core/cubit/base_state.dart';
import 'package:navigation/route_model.dart';

class RoutePreviewState extends BaseState {
  final RouteModel? route;

  RoutePreviewState(super.status, this.route, super.error);

  static RoutePreviewState loading() {
    return RoutePreviewState(Status.loading, null, null);
  }

  static RoutePreviewState success(RouteModel route) {
    return RoutePreviewState(Status.success, route, null);
  }

  static RoutePreviewState failure(Exception exception) {
    return RoutePreviewState(Status.failure, null, exception);
  }

  String formatDistance() {
    if (route == null) {
      return "";
    }

    double kilometers = route!.distanceMeters / 1000;

    return "${kilometers.toStringAsFixed(1)} km".replaceAll('.', ',');
  }

  String formatTravelTime() {
    if (route == null) {
      return "";
    }

    double minutes = route!.travelTimeSeconds / 60;

    return "${minutes.toStringAsFixed(0)} Minuten".replaceAll('.', ',');
  }
}