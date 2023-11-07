import 'dart:ui' as ui;
import 'package:core/config/config_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/marker_model.dart';
import 'package:station/repository/marker_repository.dart';
import 'package:station/repository/station_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/model/station_model.dart';
import 'package:station/ui/map/cubit/station_map_state.dart';
import 'package:station/ui/map/filter_dialog.dart';
import 'package:station/usecase/get_stations_use_case.dart';

final CameraPosition initialCameraPosition =
    CameraPosition(latLng: LatLng(51.2147194, 10.3634281), zoom: 6.0);

//TODO: continue refactoring
class StationMapCubit extends Cubit<StationMapState>
    with WidgetsBindingObserver {
  final MarkerRepository _markerRepository =
      StationModuleFactory.createSessionRepository();

  final Duration _reviewAfterFirstAppStartDuration = const Duration(days: 7);
  final Duration _refreshAfterBackgroundDuration = const Duration(minutes: 3);
  CameraPosition _position = initialCameraPosition;
  CameraPosition? _lastRequestPosition;
  Filter? _filter;
  DateTime? _lastRequestTime;

  StationMapCubit()
      : super(LoadingStationMapState(cameraPosition: initialCameraPosition)) {
    WidgetsBinding.instance.addObserver(this);

    _fetchGasFilter().then((_) => _getOwnPosition()).then((position) {
      if (position != null) {
        _position = CameraPosition(
            latLng: LatLng(position.latitude, position.longitude), zoom: 12.5);
        _fetchStations(true);
      }
    });

    _requestReviewIfNeeded();
  }

  //TODO: outsource to repository
  Future<void> _fetchGasFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gas = prefs.getString("filter_gas") ?? "e5";
    _filter = Filter(gas);
    _fetchStations(true);
  }

  void _fetchStations(bool force) {
    // Require loaded filter
    if (_filter == null) {
      return;
    }

    // Zoomed out too far, skip station loading
    if (_position.zoom < 10.5) {
      if (state is MarkersStationMapState) {
        emit(state as MarkersStationMapState);
      }

      return;
    }
    bool showLabelMarkers = _position.zoom >= 12;

    // Check for minimum map movement of 8 kilometers
    if (!force && _lastRequestPosition != null) {
      double movementDistance = Geolocator.distanceBetween(
          _lastRequestPosition!.latLng.latitude,
          _lastRequestPosition!.latLng.longitude,
          _position.latLng.latitude,
          _position.latLng.longitude);
      if (movementDistance < 8000) {
        if (state is MarkersStationMapState) {
          emit(state as MarkersStationMapState);
        }
        return;
      }
    }

    _markerRepository
        .list(
            CoordinateModel(
                _position.latLng.latitude, _position.latLng.longitude),
            20)
        .first //TODO: use stream benefits
        .then((result) {
      if (isClosed) {
        return;
      }

      result.when((markers) {
        _lastRequestTime = DateTime.now();
        _lastRequestPosition = _position;

        Future.wait(markers.map((marker) async => MapEntry(
                marker, await _genMarkerBitmap(marker, showLabelMarkers))))
            .then((entries) {
          if (isClosed) {
            return;
          }

          Map<MarkerModel, ByteData> markers = {
            for (var entry in entries) entry.key: entry.value
          };
          emit(MarkersStationMapState(
              cameraPosition: _position,
              stationMarkers: markers,
              isShowingLabelMarkers: showLabelMarkers,
              filter: _filter!));
        });
      },
          (error) => emit(ErrorStationMapState(
              cameraPosition: _position, errorDetails: error.toString())));
    });
  }

  void onRetryClicked() {
    _fetchGasFilter();
  }

  void onMoveToLocationClicked() {
    StationMapState state = this.state;
    if (state is MarkersStationMapState) {
      emit(LoadingMarkersStationMapState(
          cameraPosition: state.cameraPosition,
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: state.filter));
    } else {
      emit(LoadingStationMapState(cameraPosition: _position));
    }

    _getOwnPosition().then((position) {
      if (position != null) {
        _position = CameraPosition(
            latLng: LatLng(position.latitude, position.longitude), zoom: 12.5);
        _fetchStations(true);
      }
    });
  }

  void onFilterClicked() {
    StationMapState state = this.state;
    if (state is MarkersStationMapState) {
      emit(FilterMarkersStationMapState(
          cameraPosition: state.cameraPosition,
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: state.filter));
    }
  }

  void onCameraIdle() {
    _fetchStations(false);
  }

  void onCameraPositionChanged(CameraPosition cameraPosition) {
    _position = cameraPosition;
  }

  void onFilterSaved(Filter filter) {
    _filter = filter;

    //TODO: outsource to repository
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("filter_gas", filter.gas));

    StationMapState state = this.state;
    if (state is FilterMarkersStationMapState) {
      emit(LoadingMarkersStationMapState(
          cameraPosition: state.cameraPosition,
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: filter));
    }

    _fetchStations(true);
  }

  void onCancelFilterSettings() {
    StationMapState state = this.state;
    if (state is FilterMarkersStationMapState) {
      emit(MarkersStationMapState(
          cameraPosition: state.cameraPosition,
          stationMarkers: state.stationMarkers,
          isShowingLabelMarkers: state.isShowingLabelMarkers,
          filter: state.filter));
    }
  }

  Future<Position?> _getOwnPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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
          _fetchStations(true);
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

    if (price == null) {
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
}
