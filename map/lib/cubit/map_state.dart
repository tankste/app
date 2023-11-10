import 'package:core/cubit/base_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';

abstract class MapState {}

class LoadingMapState extends MapState {}

class ErrorMapState extends MapState {
  final String errorDetails;

  ErrorMapState(this.errorDetails);
}

class GoogleMapMapState extends MapState {}

class MapLibreMapState extends MapState {
  String styleUrlLight;
  String styleUrlDark;

  MapLibreMapState({required this.styleUrlLight, required this.styleUrlDark});
}

class AppleMapsMapState extends MapState {}
