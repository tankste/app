import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:navigation/repository/location_repository.dart';
import 'package:navigation/repository/route_repository.dart';
import 'package:navigation/ui/preview/cubit/route_preview_state.dart';
import 'package:navigation/usecase/get_route_preview_use_case.dart';

class RoutePreviewCubit extends Cubit<RoutePreviewState> {
  final CoordinateModel target;
  final GetRoutePreviewUseCase getRoutePreviewUseCase =
      GetRoutePreviewUseCaseImpl(
          GpsLocationRepository(), GoogleMapsRouteRepository());

  RoutePreviewCubit(this.target) : super(RoutePreviewState.loading()) {
    _fetchRoute();
  }

  void _fetchRoute() {
    emit(RoutePreviewState.loading());

    getRoutePreviewUseCase
        .invoke(target)
        .then((route) => emit(RoutePreviewState.success(route)))
        .catchError((error) => emit(RoutePreviewState.failure(error)));
  }

  void onRetryClicked() {
    _fetchRoute();
  }
}
