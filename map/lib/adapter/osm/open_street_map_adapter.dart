import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_street_map_flutter/open_street_map_flutter.dart' as osm;
import 'package:map/generic/generic_map.dart';
import 'package:map/adapter/map_adapter.dart';

class OpenStreetMapAdapter extends MapAdapter {
  const OpenStreetMapAdapter(
      {required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      super.polylines,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OpenStreetMapAdapterState();
}

class OpenStreetMapAdapterState extends State<OpenStreetMapAdapter> {
  Set<osm.Marker> _markers = <osm.Marker>{};

  @override
  Widget build(BuildContext context) {
    return osm.OpenStreetMap(
      initialCameraPosition: osm.CameraPosition(
          center: osm.LatLng(widget.initialCameraPosition.latLng.latitude,
              widget.initialCameraPosition.latLng.longitude),
          zoom: widget.initialCameraPosition.zoom),
      onMapCreated: (mapController) => _mapCreated(mapController),
      onCameraIdle: (_) => widget.onCameraIdle?.call(),
      onCameraMove: (position) => widget.onCameraMove?.call(CameraPosition(
          latLng: LatLng(position.center.latitude, position.center.longitude),
          zoom: position.zoom)),
      markers: _markers,
      polylines: widget.polylines
          .map((p) => osm.Polyline(
              id: p.id,
              points: p.points
                  .map(
                      (latLng) => osm.LatLng(latLng.latitude, latLng.longitude))
                  .toSet(),
              color: p.color,
              width: p.width.toDouble() * 3))
          .toSet(),
      style: osm.Style(
          invertColors: Theme.of(context).brightness == Brightness.dark),
      enableMyLocation: true,
    );
  }

  @override
  void initState() {
    super.initState();

    _convertMarkers();
  }

  @override
  void didUpdateWidget(OpenStreetMapAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Convert markers only on changes, to prevent expensive work
    if (!setEquals(oldWidget.markers.map((m) => m.id).toSet(),
        widget.markers.map((m) => m.id).toSet())) {
      _convertMarkers();
    }
  }

  void _mapCreated(osm.OpenStreetMapController mapController) {
    widget.onMapCreated(OpenStreetMapController(mapController));
  }

  Future _convertMarkers() async {
    Set<osm.Marker> markers = widget.markers
        .map((m) => osm.Marker(
            id: m.id,
            icon: m.icon,
            point: osm.LatLng(m.latLng.latitude, m.latLng.longitude),
            onTap: () => m.onTap?.call()))
        .toSet();

    setState(() {
      _markers = markers;
    });
  }
}

class OpenStreetMapController extends MapController {
  osm.OpenStreetMapController childController;

  OpenStreetMapController(this.childController);

  @override
  void moveCameraToPosition(CameraPosition position) {
    childController.animateCamera(osm.CameraPosition(
        center: osm.LatLng(position.latLng.latitude, position.latLng.longitude),
        zoom: position.zoom * 1.118));
  }

  @override
  void moveCameraToBounds(LatLngBounds bounds, double padding) {
    childController.animateCameraToBounds(
        osm.LatLngBounds(
          northeast:
              osm.LatLng(bounds.northEast.latitude, bounds.northEast.longitude),
          southwest:
              osm.LatLng(bounds.southWest.latitude, bounds.southWest.longitude),
        ),
        padding.toInt());
  }
}
