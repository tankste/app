import 'package:flutter/foundation.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/ui/map/filter_dialog.dart';

abstract class StationMapState {}

class MoveToPositionStationMapState extends StationMapState {
  final CameraPosition cameraPosition;
  final StationMapState underlyingState;

  MoveToPositionStationMapState(
      {required this.cameraPosition, required this.underlyingState});
}

class LoadingStationMapState extends StationMapState {}

class ErrorStationMapState extends StationMapState {
  String? errorDetails;

  ErrorStationMapState({this.errorDetails});
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

class LoadingMarkersStationMapState extends MarkersStationMapState {
  LoadingMarkersStationMapState(
      {required super.stationMarkers,
      required super.isShowingLabelMarkers,
      required super.filter});
}

class TooFarZoomedOutStationMapState extends StationMapState {}

class FilterMarkersStationMapState extends MarkersStationMapState {
  FilterMarkersStationMapState(
      {required super.stationMarkers,
      required super.isShowingLabelMarkers,
      required super.filter});
}

class MarkerAnnotation {
  final String id;
  final MarkerModel marker;
  final ByteData icon;

  MarkerAnnotation({required this.id, required this.marker, required this.icon});
}