import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as map_libre_maps;
import 'package:map/ui/generic/generic_map.dart';
import 'package:map/ui/generic/map_adapter.dart';

class MapLibreMapAdapter extends MapAdapter {
  final String styleUrlLight;
  final String styleUrlDark;

  const MapLibreMapAdapter(
      {required this.styleUrlLight,
      required this.styleUrlDark,
      required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      super.polylines,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MapLibreMapAdapterState();
}

class MapLibreMapAdapterState extends State<MapLibreMapAdapter> {
  final Set<map_libre_maps.Symbol> _symbols = <map_libre_maps.Symbol>{};
  final Set<map_libre_maps.Line> _lines = <map_libre_maps.Line>{};
  map_libre_maps.MaplibreMapController? _mapController;
  bool _isStyleLoaded = false;
  map_libre_maps.CameraPosition? _lastCameraPosition;

  @override
  void initState() {
    super.initState();

    _lastCameraPosition = map_libre_maps.CameraPosition(
        target: map_libre_maps.LatLng(
            widget.initialCameraPosition.latLng.latitude,
            widget.initialCameraPosition.latLng.longitude),
        zoom: widget.initialCameraPosition.zoom);

    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return map_libre_maps.MaplibreMap(
      initialCameraPosition: map_libre_maps.CameraPosition(
          target: map_libre_maps.LatLng(
              widget.initialCameraPosition.latLng.latitude,
              widget.initialCameraPosition.latLng.longitude),
          zoom: widget.initialCameraPosition.zoom),
      onMapCreated: (mapController) => _mapCreated(mapController),
      onMapIdle: () async {
        map_libre_maps.MaplibreMapController? mapController = _mapController;
        if (mapController == null) {
          return;
        }

        map_libre_maps.CameraPosition? mapLibreCameraPosition =
            _mapController?.cameraPosition;
        if (mapLibreCameraPosition == null) {
          return;
        }

        if (!mapController.isCameraMoving) {
          if (_lastCameraPosition == mapLibreCameraPosition) {
            return;
          }

          _lastCameraPosition = mapLibreCameraPosition;
          CameraPosition cameraPosition = CameraPosition(
              latLng: LatLng(mapLibreCameraPosition.target.latitude,
                  mapLibreCameraPosition.target.longitude),
              zoom: mapLibreCameraPosition.zoom);
          LatLngBounds visibleBounds = await mapController
              .getVisibleRegion()
              .then((mapLibreBounds) => LatLngBounds(
                  northEast: LatLng(mapLibreBounds.northeast.latitude,
                      mapLibreBounds.northeast.longitude),
                  southWest: LatLng(mapLibreBounds.southwest.latitude,
                      mapLibreBounds.southwest.longitude)));
          widget.onCameraMove?.call(cameraPosition, visibleBounds);

          widget.onCameraIdle?.call();
        }
      },
      styleString: Theme.of(context).brightness == Brightness.dark
          ? widget.styleUrlDark
          : widget.styleUrlLight,
      attributionButtonPosition:
          map_libre_maps.AttributionButtonPosition.BottomLeft,
      attributionButtonMargins: const Point(8, 8),
      trackCameraPosition: true,
      compassEnabled: false,
      myLocationEnabled: true,
      onStyleLoadedCallback: () {
        _isStyleLoaded = true;
        _updateMarkers();
        _updatePolylines();
      },
      myLocationTrackingMode: map_libre_maps.MyLocationTrackingMode.None,
    );
  }

  @override
  void didUpdateWidget(MapLibreMapAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Convert markers only on changes, to prevent expensive work
    if (!setEquals(oldWidget.markers.map((m) => m.id).toSet(),
        widget.markers.map((m) => m.id).toSet())) {
      _updateMarkers();
    }

    // Convert lines only on changes, to prevent expensive work
    if (!setEquals(oldWidget.polylines.map((p) => p.id).toSet(),
        widget.polylines.map((p) => p.id).toSet())) {
      _updatePolylines();
    }
  }

  void _mapCreated(map_libre_maps.MaplibreMapController mapController) {
    _mapController = mapController;
    widget.onMapCreated(MapLibreMapController(mapController));

    mapController.onSymbolTapped.add((symbol) {
      Marker? marker = symbol.data?["marker"] as Marker?;
      marker?.onTap?.call();
    });

    mapController.setSymbolIconAllowOverlap(true);

    _updateMarkers();
    _updatePolylines();
  }

  void _updateMarkers() {
    map_libre_maps.MaplibreMapController? mapController = _mapController;
    if (mapController == null) {
      return;
    }

    if (!_isStyleLoaded) {
      return;
    }

    // Remove current symbols
    mapController.removeSymbols(_symbols);
    _symbols.clear();

    for (var marker in widget.markers) {
      mapController
          .addImage("${marker.id}-image", marker.icon!.buffer.asUint8List())
          .then((_) {
        return mapController.addSymbol(
          map_libre_maps.SymbolOptions(
            geometry: map_libre_maps.LatLng(
                marker.latLng.latitude, marker.latLng.longitude),
            iconImage: "${marker.id}-image",
          ),
          {"marker": marker.withoutIcon()},
        );
      }).then((symbol) => _symbols.add(symbol));
    }
  }

  void _updatePolylines() {
    map_libre_maps.MaplibreMapController? mapController = _mapController;
    if (mapController == null) {
      return;
    }

    if (!_isStyleLoaded) {
      return;
    }

    // Remove current lines
    mapController.removeLines(_lines);
    _lines.clear();

    for (var polyline in widget.polylines) {
      mapController
          .addLine(map_libre_maps.LineOptions(
            lineColor: polyline.color.toHexStringRGB(),
            lineWidth: polyline.width.toDouble(),
            geometry: polyline.points
                .map((latLng) =>
                    map_libre_maps.LatLng(latLng.latitude, latLng.longitude))
                .toList(),
          ))
          .then((line) => _lines.add(line));
    }
  }
}

class MapLibreMapController extends MapController {
  map_libre_maps.MaplibreMapController childController;

  MapLibreMapController(this.childController);

  @override
  void moveCameraToPosition(CameraPosition position) {
    // Don't update to same position, to prevent endless looping
    if (position.latLng.latitude ==
            childController.cameraPosition?.target.latitude &&
        position.latLng.longitude ==
            childController.cameraPosition?.target.longitude &&
        position.zoom == childController.cameraPosition?.zoom) {
      return;
    }

    childController.animateCamera(map_libre_maps.CameraUpdate.newLatLngZoom(
        map_libre_maps.LatLng(
            position.latLng.latitude, position.latLng.longitude),
        position.zoom));
  }

  @override
  void moveCameraToBounds(LatLngBounds bounds, double padding) {
    childController.animateCamera(map_libre_maps.CameraUpdate.newLatLngBounds(
        map_libre_maps.LatLngBounds(
            northeast: map_libre_maps.LatLng(
                bounds.northEast.latitude, bounds.northEast.longitude),
            southwest: map_libre_maps.LatLng(
                bounds.southWest.latitude, bounds.southWest.longitude)),
        top: padding,
        bottom: padding,
        left: padding,
        right: padding));
  }

  @override
  Future<LatLngBounds> getVisibleBounds() {
    return childController.getVisibleRegion().then((bounds) => LatLngBounds(
        northEast:
            LatLng(bounds.northeast.latitude, bounds.northeast.longitude),
        southWest:
            LatLng(bounds.southwest.latitude, bounds.southwest.longitude)));
  }
}
