import 'package:flutter/foundation.dart';
import 'package:map/map_models.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/ui/map/filter_dialog.dart';

abstract class StationMapState {
  bool isNorthButtonVisible;

  StationMapState({required this.isNorthButtonVisible});

  StationMapState copyWith({bool? isNorthButtonVisible});
}

class EmptyStationMapState extends StationMapState {
  EmptyStationMapState({required super.isNorthButtonVisible});

  @override
  EmptyStationMapState copyWith({bool? isNorthButtonVisible}) {
    return EmptyStationMapState(
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

abstract class LoadingStationMapState extends StationMapState {
  LoadingStationMapState({required super.isNorthButtonVisible});
}

class InitFilterLoadingStationMapState extends LoadingStationMapState {
  InitFilterLoadingStationMapState({required super.isNorthButtonVisible});

  @override
  InitFilterLoadingStationMapState copyWith({bool? isNorthButtonVisible}) {
    return InitFilterLoadingStationMapState(
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class InitPositionLoadingStationMapState extends LoadingStationMapState {
  InitPositionLoadingStationMapState({required super.isNorthButtonVisible});

  @override
  InitPositionLoadingStationMapState copyWith({bool? isNorthButtonVisible}) {
    return InitPositionLoadingStationMapState(
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MoveToInitLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToInitLoadingStationMapState({
    required this.cameraPosition,
    required super.isNorthButtonVisible,
  });

  @override
  MoveToInitLoadingStationMapState copyWith({
    CameraPosition? cameraPosition,
    bool? isNorthButtonVisible,
  }) {
    return MoveToInitLoadingStationMapState(
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class LoadingInitMarkersStationMapState extends LoadingStationMapState {
  LoadingInitMarkersStationMapState({required super.isNorthButtonVisible});

  @override
  LoadingInitMarkersStationMapState copyWith({bool? isNorthButtonVisible}) {
    return LoadingInitMarkersStationMapState(
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class FindOwnPositionLoadingStationMapState extends LoadingStationMapState {
  final StationMapState underlyingState;

  FindOwnPositionLoadingStationMapState({
    required this.underlyingState,
    required super.isNorthButtonVisible,
  });

  @override
  FindOwnPositionLoadingStationMapState copyWith({
    StationMapState? underlyingState,
    bool? isNorthButtonVisible,
  }) {
    return FindOwnPositionLoadingStationMapState(
      underlyingState: underlyingState ?? this.underlyingState,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MoveToOwnLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToOwnLoadingStationMapState({
    required this.cameraPosition,
    required super.isNorthButtonVisible,
  });

  @override
  MoveToOwnLoadingStationMapState copyWith({
    CameraPosition? cameraPosition,
    bool? isNorthButtonVisible,
  }) {
    return MoveToOwnLoadingStationMapState(
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MoveToZoomedInLoadingStationMapState extends LoadingStationMapState {
  final CameraPosition cameraPosition;

  MoveToZoomedInLoadingStationMapState({
    required this.cameraPosition,
    required super.isNorthButtonVisible,
  });

  @override
  MoveToZoomedInLoadingStationMapState copyWith({
    CameraPosition? cameraPosition,
    bool? isNorthButtonVisible,
  }) {
    return MoveToZoomedInLoadingStationMapState(
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class LoadingMarkersStationMapState extends LoadingStationMapState {
  final StationMapState underlyingState;

  LoadingMarkersStationMapState({
    required this.underlyingState,
    required super.isNorthButtonVisible,
  });

  @override
  LoadingMarkersStationMapState copyWith({
    StationMapState? underlyingState,
    bool? isNorthButtonVisible,
  }) {
    return LoadingMarkersStationMapState(
      underlyingState: underlyingState ?? this.underlyingState,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MarkersStationMapState extends StationMapState {
  List<MarkerAnnotation> stationMarkers;
  bool isShowingLabelMarkers;
  Filter filter;

  MarkersStationMapState({
    required this.stationMarkers,
    required this.isShowingLabelMarkers,
    required this.filter,
    required super.isNorthButtonVisible,
  });

  @override
  MarkersStationMapState copyWith({
    List<MarkerAnnotation>? stationMarkers,
    bool? isShowingLabelMarkers,
    Filter? filter,
    bool? isNorthButtonVisible,
  }) {
    return MarkersStationMapState(
      stationMarkers: stationMarkers ?? this.stationMarkers,
      isShowingLabelMarkers:
          isShowingLabelMarkers ?? this.isShowingLabelMarkers,
      filter: filter ?? this.filter,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class FilterDialogStationMapState extends StationMapState {
  Filter filter;
  StationMapState underlyingState;

  FilterDialogStationMapState({
    required this.filter,
    required this.underlyingState,
    required super.isNorthButtonVisible,
  });

  @override
  FilterDialogStationMapState copyWith({
    Filter? filter,
    StationMapState? underlyingState,
    bool? isNorthButtonVisible,
  }) {
    return FilterDialogStationMapState(
      filter: filter ?? this.filter,
      underlyingState: underlyingState ?? this.underlyingState,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class TooFarZoomedOutStationMapState extends StationMapState {
  TooFarZoomedOutStationMapState({required super.isNorthButtonVisible});

  @override
  TooFarZoomedOutStationMapState copyWith({bool? isNorthButtonVisible}) {
    return TooFarZoomedOutStationMapState(
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MoveToBearingStationMapState extends StationMapState {
  final double bearing;
  final StationMapState underlyingState;

  MoveToBearingStationMapState({
    required this.underlyingState,
    required this.bearing,
    required super.isNorthButtonVisible,
  });

  @override
  MoveToBearingStationMapState copyWith({
    double? bearing,
    StationMapState? underlyingState,
    bool? isNorthButtonVisible,
  }) {
    return MoveToBearingStationMapState(
      bearing: bearing ?? this.bearing,
      underlyingState: underlyingState ?? this.underlyingState,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class ErrorStationMapState extends StationMapState {
  String? errorDetails;

  ErrorStationMapState({
    this.errorDetails,
    required super.isNorthButtonVisible,
  });

  @override
  ErrorStationMapState copyWith({
    String? errorDetails,
    bool? isNorthButtonVisible,
  }) {
    return ErrorStationMapState(
      errorDetails: errorDetails ?? this.errorDetails,
      isNorthButtonVisible: isNorthButtonVisible ?? this.isNorthButtonVisible,
    );
  }
}

class MarkerAnnotation {
  final String id;
  final MarkerModel marker;
  final ByteData icon;

  MarkerAnnotation({
    required this.id,
    required this.marker,
    required this.icon,
  });
}
