import 'package:core/cubit/base_state.dart';
import 'package:flutter/foundation.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/ui/map/filter_dialog.dart';

abstract class StationMapState {
  CameraPosition cameraPosition;

  StationMapState({required this.cameraPosition});
}

class LoadingStationMapState extends StationMapState {
  LoadingStationMapState({required super.cameraPosition});
}

class ErrorStationMapState extends StationMapState {
  String? errorDetails;

  ErrorStationMapState({this.errorDetails, required super.cameraPosition});
}

class MarkersStationMapState extends StationMapState {
  Map<MarkerModel, ByteData> stationMarkers;
  bool isShowingLabelMarkers;
  Filter filter;

  MarkersStationMapState(
      {required this.stationMarkers,
      required this.isShowingLabelMarkers,
      required this.filter, required super.cameraPosition});
}

class LoadingMarkersStationMapState extends MarkersStationMapState {
  LoadingMarkersStationMapState(
      {required super.stationMarkers,
      required super.isShowingLabelMarkers,
      required super.filter, required super.cameraPosition});
}

class FilterMarkersStationMapState extends MarkersStationMapState {
  FilterMarkersStationMapState(
      {required super.stationMarkers,
      required super.isShowingLabelMarkers,
      required super.filter, required super.cameraPosition});
}
