import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:map/generic/generic_map.dart';
import 'package:map/adapter/map_adapter.dart';

class GoogleMapAdapter extends MapAdapter {
  const GoogleMapAdapter(
      {required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      super.polylines,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => GoogleMapAdapterState();
}

class GoogleMapAdapterState extends State<GoogleMapAdapter> {
  Set<google_maps.Marker> _markers = <google_maps.Marker>{};
  google_maps.GoogleMapController? _mapController;
  bool? _isDark;

  @override
  Widget build(BuildContext context) {
    return google_maps.GoogleMap(
      initialCameraPosition: google_maps.CameraPosition(
          target: google_maps.LatLng(
              widget.initialCameraPosition.latLng.latitude,
              widget.initialCameraPosition.latLng.longitude),
          zoom: widget.initialCameraPosition.zoom),
      onMapCreated: (mapController) => _mapCreated(mapController),
      onCameraIdle: () => widget.onCameraIdle?.call(),
      onCameraMove: (position) => widget.onCameraMove?.call(CameraPosition(
          latLng: LatLng(position.target.latitude, position.target.longitude),
          zoom: position.zoom)),
      markers: _markers,
      polylines: widget.polylines
          .map((p) => google_maps.Polyline(
              polylineId: google_maps.PolylineId(p.id),
              points: p.points
                  .map((latLng) =>
                      google_maps.LatLng(latLng.latitude, latLng.longitude))
                  .toList(),
              color: p.color,
              width: p.width))
          .toSet(),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
    );
  }

  @override
  void initState() {
    super.initState();

    _checkTheme();
    _convertMarkers();
  }

  @override
  void didUpdateWidget(GoogleMapAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkTheme();

    // Convert markers only on changes, to prevent expensive work
    if (!setEquals(oldWidget.markers.map((m) => m.id).toSet(),
        widget.markers.map((m) => m.id).toSet())) {
      _convertMarkers();
    }
  }

  void _mapCreated(google_maps.GoogleMapController mapController) {
    _mapController = mapController;
    widget.onMapCreated(GoogleMapController(mapController));
  }

  void _checkTheme() {
    if (_mapController == null) {
      return;
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isDark == isDark) {
      return;
    }

    var path = "assets/google_maps/styles/light.json";
    if (isDark) {
      path = "assets/google_maps/styles/dark.json";
    }

    rootBundle
        .loadString(path)
        .then((value) => _mapController?.setMapStyle(value));
  }

  Future _convertMarkers() async {
    Set<google_maps.Marker> markers = widget.markers
        .map((m) => google_maps.Marker(
            markerId: google_maps.MarkerId(m.id),
            icon: m.icon != null
                ? google_maps.BitmapDescriptor.fromBytes(
                    m.icon!.buffer.asUint8List())
                : google_maps.BitmapDescriptor.defaultMarkerWithHue(
                    google_maps.BitmapDescriptor.hueAzure),
            position: google_maps.LatLng(m.latLng.latitude, m.latLng.longitude),
            onTap: () => m.onTap?.call()))
        .toSet();

    setState(() {
      _markers = markers;
    });
  }
}

class GoogleMapController extends MapController {
  google_maps.GoogleMapController childController;

  GoogleMapController(this.childController);

  @override
  void moveCameraToPosition(CameraPosition position) {
    childController.animateCamera(google_maps.CameraUpdate.newLatLngZoom(
        google_maps.LatLng(position.latLng.latitude, position.latLng.longitude),
        position.zoom));
  }

  @override
  void moveCameraToBounds(LatLngBounds bounds, double padding) {
    childController.animateCamera(google_maps.CameraUpdate.newLatLngBounds(
        google_maps.LatLngBounds(
            northeast: google_maps.LatLng(
                bounds.northEast.latitude, bounds.northEast.longitude),
            southwest: google_maps.LatLng(
                bounds.southWest.latitude, bounds.southWest.longitude)),
        padding));
  }
}
