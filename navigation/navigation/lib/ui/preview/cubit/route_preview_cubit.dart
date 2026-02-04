import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:navigation/ui/preview/cubit/route_preview_state.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/repository/route_repository.dart';
import 'package:navigation_impl/di/navigation_impl_module_factory.dart';

class RoutePreviewCubit extends Cubit<RoutePreviewState> {
  final RouteRepository _routeRepository =
      NavigationImplModuleFactory.createRouteRepository();
  final LocationRepository _locationRepository =
      LocationModuleFactory.createLocationRepository();
  final CoordinateModel target;

  RoutePreviewCubit(this.target)
      : super(LoadingRoutePreviewState(target: target)) {
    _fetchLocation();
  }

  void _fetchLocation() {
    emit(LoadingRoutePreviewState(target: target));

    _locationRepository.getCurrentLocation().then((location) {
      if (isClosed) {
        return;
      }

      if (location == null) {
        emit(NoRouteRoutePreviewState(target: target));
        return;
      }

      _fetchRoute(location.coordinate);
    });
  }

  void _fetchRoute(CoordinateModel location) {
    _routeRepository.getRoutePreview(location, target).then((result) {
      if (isClosed) {
        return;
      }

      emit(result.when((route) {
        return RouteRoutePreviewState(
            distance: _formatDistance(route.distanceMeters),
            time: _formatTravelTime(route.travelTimeSeconds),
            coordinates: route.routeCoordinates,
            target: target);
      }, (error) => NoRouteRoutePreviewState(target: target)));
    });
  }

  void onRetryClicked() {
    _fetchLocation();
  }

  String _formatDistance(int distanceMeters) {
    double kilometers = distanceMeters / 1000;
    return tr('generic.units.kilometers.short',
        args: [kilometers.toStringAsFixed(1)]).replaceAll('.', ',');
  }

  String _formatTravelTime(int travelTimeSeconds) {
    int totalMinutes = (travelTimeSeconds / 60).toInt(); // Convert to int

    if (totalMinutes >= 60) {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      if (minutes == 0) {
        return tr(
          hours == 1
              ? 'generic.units.hour.singular'
              : 'generic.units.hour.plural',
          args: [hours.toString()],
        ).replaceAll('.', ',');
      } else {
        String hourText = tr(
          hours == 1 ? 'generic.units.hour.long' : 'generic.units.hours.long',
          args: [hours.toString()],
        );
        String minuteText = tr(
          minutes == 1
              ? 'generic.units.minute.long'
              : 'generic.units.minutes.long',
          args: [minutes.toString()],
        );

        return '$hourText $minuteText'.replaceAll('.', ',');
      }
    } else {
      return tr(
        totalMinutes == 1
            ? 'generic.units.minute.long'
            : 'generic.units.minutes.long',
        args: [totalMinutes.toString()],
      ).replaceAll('.', ',');
    }
  }
}
