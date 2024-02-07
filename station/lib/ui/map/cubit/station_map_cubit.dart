import 'dart:ui' as ui;
import 'package:core/log/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:map/di/map_module_factory.dart';
import 'package:map/model/camera_position_model.dart';
import 'package:map/repository/camera_position_repository.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/permission_model.dart';
import 'package:settings/repository/permission_repository.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/repository/marker_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/ui/map/cubit/station_map_state.dart';
import 'package:station/ui/map/filter_dialog.dart';

final CameraPosition initialCameraPosition =
    CameraPosition(latLng: LatLng(51.2147194, 10.3634281), zoom: 6.0);

//TODO: continue refactoring
class StationMapCubit extends Cubit<StationMapState>
    with WidgetsBindingObserver {
  final double _minZoom = 10.5;
  final MarkerRepository _markerRepository =
      StationModuleFactory.createMarkerRepository();
  final PermissionRepository _permissionRepository =
      SettingsModuleFactory.createPermissionRepository();
  final CameraPositionRepository _cameraPositionRepository =
      MapModuleFactory.createCameraPositionRepository();

  final double _boundaryQueryPadding = 0.03; // ~ 3 kilometers
  final Duration _reviewAfterFirstAppStartDuration = const Duration(days: 7);
  final Duration _refreshAfterBackgroundDuration = const Duration(minutes: 3);
  CameraPosition _position = initialCameraPosition;
  CameraPosition? _lastRequestPosition;
  LatLngBounds? _visibleBounds;
  Filter? _filter;
  DateTime? _lastRequestTime;
  Future? _stationRequest;
  bool _hasInitialMovementDone = false;
  int _requestNumber = 0;
  bool _fetchForced = false;

  StationMapCubit() : super(EmptyStationMapState()) {
    WidgetsBinding.instance.addObserver(this);

    _requestReviewIfNeeded();
  }

  void onMapReady() {
    _init();
  }

  void _init() {
    _hasInitialMovementDone = false;

    _fetchGasFilter().then((_) => _moveToOwnOrLastLocation());
  }

  //TODO: outsource to repository
  Future<void> _fetchGasFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gas = prefs.getString("filter_gas") ?? "e5";
    _filter = Filter(gas);
  }

  void _fetchStations(
      CameraPosition position, LatLngBounds visibleBounds, bool force) {
    StationMapState state = this.state;
    if (state is PositionLoadingStationMapState) {
      return;
    }

    state = _getRootState();

    // Require loaded filter
    if (_filter == null) {
      if (state is MarkersStationMapState) {
        emit(MarkersStationMapState(
            stationMarkers: state.stationMarkers,
            isShowingLabelMarkers: state.isShowingLabelMarkers,
            filter: state.filter));
      }
      return;
    }
    Filter filter = _filter!;
    int requestNumber = ++_requestNumber;

    // Zoomed out too far, skip station loading
    if (position.zoom < _minZoom) {
      emit(TooFarZoomedOutStationMapState());
      return;
    }
    bool showLabelMarkers = position.zoom >= 12;

    if (!force && _lastRequestPosition != null) {
      double movementDistance = Geolocator.distanceBetween(
          _lastRequestPosition!.latLng.latitude,
          _lastRequestPosition!.latLng.longitude,
          position.latLng.latitude,
          position.latLng.longitude);

      if (movementDistance < 300) {
        if (state is MarkersStationMapState) {
          emit(MarkersStationMapState(
              stationMarkers: state.stationMarkers,
              isShowingLabelMarkers: state.isShowingLabelMarkers,
              filter: state.filter));
        }
        return;
      }
    }

    emit(StationLoadingStationMapState(underlyingState: state));

    _stationRequest?.ignore();
    _stationRequest = _markerRepository
        .list([
          CoordinateModel(
              latitude:
                  visibleBounds.southWest.latitude - _boundaryQueryPadding,
              longitude:
                  visibleBounds.southWest.longitude - _boundaryQueryPadding),
          CoordinateModel(
              latitude:
                  visibleBounds.northEast.latitude + _boundaryQueryPadding,
              longitude:
                  visibleBounds.northEast.longitude + _boundaryQueryPadding),
        ])
        .first //TODO: use stream benefits
        .then((result) {
          if (isClosed) {
            return;
          }

          // Ignore this request, when other one is already in progress
          if (requestNumber < _requestNumber) {
            return;
          }

          result.when((markers) {
            Future.wait(markers.map((marker) async => MarkerAnnotation(
                id:
                    "${marker.id}-${filter.gas}#${Object.hash(marker.e5Price, marker.e5PriceState, marker.e10Price, marker.e10PriceState, marker.dieselPrice, marker.dieselPriceState, showLabelMarkers ? "label" : "dot")}",
                marker: marker,
                icon: await _genMarkerBitmap(
                    marker, showLabelMarkers)))).then((markers) {
              if (isClosed) {
                return;
              }

              _lastRequestTime = DateTime.now();
              _lastRequestPosition = position;

              emit(MarkersStationMapState(
                  stationMarkers: markers,
                  isShowingLabelMarkers: showLabelMarkers,
                  filter: _filter!));
            });
          },
              (error) =>
                  emit(ErrorStationMapState(errorDetails: error.toString())));
        });
  }

  void onRetryClicked() {
    if (_visibleBounds != null) {
      _fetchStations(_position, _visibleBounds!, true);
    } else if (_filter != null) {
      _moveToOwnLocation();
    } else {
      _init();
    }
  }

  void onMoveToLocationClicked() {
    _moveToOwnLocation();
  }

  void onZoomInfoClicked() {
    CameraPosition zoomedCameraPosition =
        CameraPosition(latLng: _position.latLng, zoom: 12.5);

    emit(MoveToPositionStationMapState(
        cameraPosition: zoomedCameraPosition, underlyingState: state));
  }

  void _moveToOwnOrLastLocation() {
    StationMapState state = _getRootState();
    emit(PositionLoadingStationMapState(underlyingState: state));

    _getOwnPosition(false).then((result) {
      result.when((position) {
        _hasInitialMovementDone = true;

        if (position != null) {
          CameraPosition newPosition = CameraPosition(
              latLng: LatLng(position.latitude, position.longitude),
              zoom: 12.5);

          if (newPosition != _position) {
            _position = newPosition;

            // Stations fetched automatically after map has moved
            emit(MoveToPositionStationMapState(
                cameraPosition: _position, underlyingState: state));
          } else {
            emit(state);
          }
        } else {

          _cameraPositionRepository.getLast().first.then((result) {
            if (isClosed) {
              return;
            }

            emit(result.when((cameraPosition) {
              _hasInitialMovementDone = true;

              if (cameraPosition != null) {
                _position = CameraPosition(
                    latLng: LatLng(
                        cameraPosition.latitude, cameraPosition.longitude),
                    zoom: cameraPosition.zoom);

                return MoveToPositionStationMapState(
                    cameraPosition: CameraPosition(
                        latLng: LatLng(
                            cameraPosition.latitude, cameraPosition.longitude),
                        zoom: cameraPosition.zoom),
                    underlyingState: state);
              } else {
                return TooFarZoomedOutStationMapState();
              }
            },
                (error) =>
                    ErrorStationMapState(errorDetails: error.toString())));
          });
        }
      }, (error) {
        emit(ErrorStationMapState(errorDetails: error.toString()));
      });
    });
  }

  void _moveToOwnLocation() {
    StationMapState state = _getRootState();
    emit(PositionLoadingStationMapState(underlyingState: state));

    _getOwnPosition(true).then((result) {
      result.when((position) {
        if (position != null) {
          CameraPosition newPosition = CameraPosition(
              latLng: LatLng(position.latitude, position.longitude),
              zoom: 12.5);

          if (newPosition != _position) {
            _position = newPosition;

            _fetchForced = true;
            // Stations fetched automatically after map has moved
            emit(MoveToPositionStationMapState(
                cameraPosition: _position, underlyingState: state));
          } else {
            emit(state);
          }
        } else {
          emit(state);
        }
      }, (error) {
        emit(ErrorStationMapState(errorDetails: error.toString()));
      });
    });
  }

  void onFilterClicked() {
    StationMapState state = this.state;
    if (state is MarkersStationMapState) {
      emit(FilterMarkersStationMapState(
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: state.filter));
    }
  }

  void onCameraIdle() {
    if (_visibleBounds != null) {
      emit(StationLoadingStationMapState(underlyingState: _getRootState()));
      _fetchStations(_position, _visibleBounds!, _fetchForced);
      _fetchForced = false;
    }
  }

  void onCameraPositionChanged(
      CameraPosition cameraPosition, LatLngBounds? bounds) {
    _position = cameraPosition;
    _visibleBounds = bounds;

    if (_hasInitialMovementDone) {
      _cameraPositionRepository.updateLast(CameraPositionModel(
          latitude: cameraPosition.latLng.latitude,
          longitude: cameraPosition.latLng.longitude,
          zoom: cameraPosition.zoom));
    }
  }

  void onFilterSaved(Filter filter) {
    _filter = filter;

    //TODO: outsource to repository
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("filter_gas", filter.gas));

    StationMapState state = this.state;
    if (state is FilterMarkersStationMapState) {
      emit(StationLoadingStationMapState(
          underlyingState: MarkersStationMapState(
              stationMarkers: state.stationMarkers,
              isShowingLabelMarkers: state.isShowingLabelMarkers,
              filter: state.filter)));
    }

    if (_visibleBounds != null) {
      _fetchStations(_position, _visibleBounds!, true);
    }
  }

  void onCancelFilterSettings() {
    StationMapState state = this.state;
    if (state is FilterMarkersStationMapState) {
      emit(MarkersStationMapState(
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: state.filter));
    }
  }

  Future<Result<Position?, Exception>> _getOwnPosition(
      bool forcePermissionRequest) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Result.success(
          null); //TODO: show hint, when the location was user requested
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Result<PermissionModel, Exception> locationPermissionResult =
          await _permissionRepository.getLocationPermission().first;
      if (locationPermissionResult.isError()) {
        return Result.error(locationPermissionResult.tryGetError()!);
      }

      PermissionModel locationPermission =
          locationPermissionResult.tryGetSuccess()!;

      // Ask for permission only once, or if the user request by locate me button
      if (!forcePermissionRequest && locationPermission.hasRequested) {
        return Result.success(null);
      }

      permission = await Geolocator.requestPermission();
      _permissionRepository.updateLocationPermission(
          locationPermission.copyWith(hasRequested: true));

      if (permission == LocationPermission.denied) {
        return Result.success(null);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Result.success(null);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return Result.success(position);
  }

  Future<void> _requestReviewIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int firstAppStartMilliseconds = prefs.getInt("first_app_start") ?? -1;
    if (firstAppStartMilliseconds == -1) {
      await prefs.setInt(
          "first_app_start", DateTime.now().millisecondsSinceEpoch);
    } else {
      DateTime firstAppStart =
          DateTime.fromMillisecondsSinceEpoch(firstAppStartMilliseconds);
      DateTime thresholdDate =
          firstAppStart.add(_reviewAfterFirstAppStartDuration);
      if (DateTime.now().isAfter(thresholdDate)) {
        InAppReview inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
        }
      }
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lastRequestTime != null) {
        DateTime thresholdDate =
            _lastRequestTime!.add(_refreshAfterBackgroundDuration);
        if (DateTime.now().isAfter(thresholdDate)) {
          if (_visibleBounds != null) {
            _fetchStations(_position, _visibleBounds!, true);
          }
        }
      }
    }
  }

  Future<ByteData> _genMarkerBitmap(
      MarkerModel marker, bool isShowingLabelMarkers) {
    if (isShowingLabelMarkers) {
      return _genLabelMarkerBitmap(marker);
    } else {
      return _genDotMarkerBitmap(marker);
    }
  }

  Future<ByteData> _genDotMarkerBitmap(MarkerModel marker) async {
    String path;

    if (_filter?.gas == "e5") {
      switch (marker.e5PriceState) {
        case PriceState.expensive:
          path = 'assets/images/markers/red.png';
          break;
        case PriceState.medium:
          path = 'assets/images/markers/orange.png';
          break;
        case PriceState.cheap:
          path = 'assets/images/markers/green.png';
          break;
        default:
          path = 'assets/images/markers/grey.png';
      }
    } else if (_filter?.gas == "e10") {
      switch (marker.e10PriceState) {
        case PriceState.expensive:
          path = 'assets/images/markers/red.png';
          break;
        case PriceState.medium:
          path = 'assets/images/markers/orange.png';
          break;
        case PriceState.cheap:
          path = 'assets/images/markers/green.png';
          break;
        default:
          path = 'assets/images/markers/grey.png';
      }
    } else if (_filter?.gas == "diesel") {
      switch (marker.dieselPriceState) {
        case PriceState.expensive:
          path = 'assets/images/markers/red.png';
          break;
        case PriceState.medium:
          path = 'assets/images/markers/orange.png';
          break;
        case PriceState.cheap:
          path = 'assets/images/markers/green.png';
          break;
        default:
          path = 'assets/images/markers/grey.png';
      }
    } else {
      path = 'assets/images/markers/grey.png';
    }

    String resolutionName = await AssetImage(path)
        .obtainKey(ImageConfiguration.empty)
        .then((value) => value.name);

    return await rootBundle.load(resolutionName);
  }

  Future<ByteData> _genLabelMarkerBitmap(MarkerModel marker) async {
    double ratio = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
        .devicePixelRatio;

    // Ratio version *
    double padding = 1.6 * ratio;
    double textPadding = 3.2 * ratio;
    double triangleSize = 8.0 * ratio;
    double maxWidth = 51.2 * ratio;
    double brandFontSize = 8.0 * ratio;
    double priceFontSize = 14.4 * ratio;

    // Create canvas
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Create bar name text
    var brandParagraph =
        (ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: ui.TextAlign.left))
              ..pushStyle(ui.TextStyle(
                color: Colors.white70,
                fontSize: brandFontSize,
              ))
              ..addText(marker.label.length > 8
                  ? "${marker.label.substring(0, 5)}..."
                  : marker.label))
            .build();

    String priceText;

    double? price;
    if (_filter?.gas == "e5") {
      price = marker.e5Price;
    } else if (_filter?.gas == "e10") {
      price = marker.e10Price;
    } else if (_filter?.gas == "diesel") {
      price = marker.dieselPrice;
    } else {
      price = null;
    }

    if (price == null || price == 0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = price.toStringAsFixed(3).replaceAll('.', ',');
    }

    if (priceText.length == 5) {
      priceText = priceText
          .replaceFirst('0', '\u{2070}', 4)
          .replaceFirst('1', '\u{00B9}', 4)
          .replaceFirst('2', '\u{00B2}', 4)
          .replaceFirst('3', '\u{00B3}', 4)
          .replaceFirst('4', '\u{2074}', 4)
          .replaceFirst('5', '\u{2075}', 4)
          .replaceFirst('6', '\u{2076}', 4)
          .replaceFirst('7', '\u{2077}', 4)
          .replaceFirst('8', '\u{2078}', 4)
          .replaceFirst('9', '\u{2079}', 4);
    }

    var priceParagraph =
        (ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: ui.TextAlign.left))
              ..pushStyle(ui.TextStyle(
                  color: Colors.white,
                  fontSize: priceFontSize,
                  fontWeight: FontWeight.bold))
              ..addText(priceText))
            .build();

    ui.ParagraphConstraints constraints =
        ui.ParagraphConstraints(width: maxWidth);
    brandParagraph.layout(constraints);
    priceParagraph.layout(constraints);

    // Create background rect
    final backgroundPaint = Paint();
    if (_filter?.gas == "e5") {
      switch (marker.e5PriceState) {
        case PriceState.expensive:
          backgroundPaint.color = Colors.red;
          break;
        case PriceState.medium:
          backgroundPaint.color = Colors.orange;
          break;
        case PriceState.cheap:
          backgroundPaint.color = Colors.green;
          break;
        default:
          backgroundPaint.color = Colors.grey;
      }
    } else if (_filter?.gas == "e10") {
      switch (marker.e10PriceState) {
        case PriceState.expensive:
          backgroundPaint.color = Colors.red;
          break;
        case PriceState.medium:
          backgroundPaint.color = Colors.orange;
          break;
        case PriceState.cheap:
          backgroundPaint.color = Colors.green;
          break;
        default:
          backgroundPaint.color = Colors.grey;
      }
    } else if (_filter?.gas == "diesel") {
      switch (marker.dieselPriceState) {
        case PriceState.expensive:
          backgroundPaint.color = Colors.red;
          break;
        case PriceState.medium:
          backgroundPaint.color = Colors.orange;
          break;
        case PriceState.cheap:
          backgroundPaint.color = Colors.green;
          break;
        default:
          backgroundPaint.color = Colors.grey;
      }
    } else {
      backgroundPaint.color = Colors.grey;
    }

    final labelHeight = padding +
        textPadding +
        brandParagraph.height +
        priceParagraph.height +
        padding;

    var rect = Rect.fromLTWH(0, 0, maxWidth, labelHeight);
    var rrect = RRect.fromRectXY(rect, 12, 12);

    // Create triangle path
    var trianglePath = Path();
    trianglePath.moveTo(
        maxWidth / 2, labelHeight + triangleSize - (1 * ratio)); // Bottom
    trianglePath.lineTo(
        maxWidth / 2 - triangleSize, labelHeight - (1 * ratio)); // Top-Left
    trianglePath.lineTo(
        maxWidth / 2 + triangleSize, labelHeight - (1 * ratio)); // Top-Right
    trianglePath.close();

    // Draw background
    // canvas.drawRect(rect, backgroundPaint);
    canvas.drawRRect(rrect, backgroundPaint);

    // Draw text
    canvas.drawParagraph(
        brandParagraph, Offset(padding + textPadding, padding + textPadding));
    canvas.drawParagraph(priceParagraph,
        Offset(padding + textPadding, padding + textPadding + brandFontSize));

    // Draw trianglePath path
    canvas.drawPath(trianglePath, backgroundPaint);

    final img = await pictureRecorder
        .endRecording()
        .toImage(maxWidth.toInt(), labelHeight.toInt() + triangleSize.toInt());

    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!;
  }

  StationMapState _getRootState() {
    StationMapState state = this.state;
    if (state is MoveToPositionStationMapState) {
      state = state.underlyingState;
    } else if (state is LoadingStationMapState) {
      state = state.underlyingState;
    }
    return state;
  }
}
