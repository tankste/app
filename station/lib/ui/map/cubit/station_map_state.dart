import 'package:flutter/foundation.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/ui/map/filter_dialog.dart';

abstract class StationMapState {}

class EmptyStationMapState extends StationMapState {}

abstract class LoadingStationMapState extends StationMapState {}

class InitFilterLoadingStationMapState extends LoadingStationMapState {}

class InitPositionLoadingStationMapState extends LoadingStationMapState {}

class MoveToInitLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToInitLoadingStationMapState({required this.cameraPosition});
}

class LoadingInitMarkersStationMapState extends LoadingStationMapState {}

class FindOwnPositionLoadingStationMapState extends LoadingStationMapState {
  final StationMapState underlyingState;

  FindOwnPositionLoadingStationMapState({required this.underlyingState});
}

class MoveToOwnLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToOwnLoadingStationMapState({required this.cameraPosition});
}

class MoveToZoomedInLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToZoomedInLoadingStationMapState({required this.cameraPosition});
}

class LoadingMarkersStationMapState extends LoadingStationMapState {
  final StationMapState underlyingState;

  LoadingMarkersStationMapState({required this.underlyingState});
}

class MarkersStationMapState extends StationMapState {
  List<MarkerAnnotation> stationMarkers;
  bool isShowingLabelMarkers;
  Filter filter;

  MarkersStationMapState(
      {required this.stationMarkers,
      required this.isShowingLabelMarkers,
      required this.filter});
}

class FilterDialogStationMapState extends StationMapState {
  Filter filter;
  StationMapState underlyingState;

  FilterDialogStationMapState({
    required this.filter,
    required this.underlyingState,
  });
}

class TooFarZoomedOutStationMapState extends StationMapState {}

class ErrorStationMapState extends StationMapState {
  String? errorDetails;

  ErrorStationMapState({this.errorDetails});
}

class MarkerAnnotation {
  final String id;
  final MarkerModel marker;
  final ByteData icon;

  MarkerAnnotation(
      {required this.id, required this.marker, required this.icon});
}
