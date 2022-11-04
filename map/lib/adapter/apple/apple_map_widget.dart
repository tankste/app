import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple_maps;
import 'package:map/adapter/map_adapter.dart';
import 'package:map/generic/generic_map.dart';

class AppleMapAdapter extends MapAdapter {
  const AppleMapAdapter(
      {required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      super.polylines,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AppleMapAdapterState();
}

class AppleMapAdapterState extends State<AppleMapAdapter> {
  Set<apple_maps.Annotation> _annotations = <apple_maps.Annotation>{};

  @override
  Widget build(BuildContext context) {
    return apple_maps.AppleMap(
      initialCameraPosition: apple_maps.CameraPosition(
          target: apple_maps.LatLng(
              widget.initialCameraPosition.latLng.latitude,
              widget.initialCameraPosition.latLng.longitude),
          zoom: widget.initialCameraPosition.zoom),
      onMapCreated: (mapController) {
        widget.onMapCreated(AppleMapController(mapController));
      },
      onCameraIdle: () => widget.onCameraIdle?.call(),
      onCameraMove: (position) => widget.onCameraMove?.call(CameraPosition(
          latLng: LatLng(position.target.latitude, position.target.longitude),
          zoom: position.zoom)),
      annotations: _annotations,
      polylines: widget.polylines
          .map((p) => apple_maps.Polyline(
              polylineId: apple_maps.PolylineId(p.id),
              points: p.points
                  .map((latLng) =>
                      apple_maps.LatLng(latLng.latitude, latLng.longitude))
                  .toList(),
              color: p.color,
              width: p.width))
          .toSet(),
      myLocationButtonEnabled: false,
      compassEnabled: false,
      myLocationEnabled: true,
    );
  }

  @override
  void initState() {
    super.initState();

    _convertMarkers();
  }

  @override
  void didUpdateWidget(AppleMapAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Convert markers only on changes, to prevent expensive work
    if (!setEquals(oldWidget.markers.map((m) => m.id).toSet(),
        widget.markers.map((m) => m.id).toSet())) {
      _convertMarkers();
    }
  }

  Future _convertMarkers() async {
    Set<apple_maps.Annotation> annotations = widget.markers
        .map((m) => apple_maps.Annotation(
            annotationId: apple_maps.AnnotationId(m.id),
            icon: m.icon != null
                ? apple_maps.BitmapDescriptor.fromBytes(
                    m.icon!.buffer.asUint8List())
                : apple_maps.BitmapDescriptor.defaultAnnotationWithHue(
                    apple_maps.BitmapDescriptor.hueAzure),
            position: apple_maps.LatLng(m.latLng.latitude, m.latLng.longitude),
            onTap: () => m.onTap?.call()))
        .toSet();

    setState(() {
      _annotations = annotations;
    });
  }
}

class AppleMapController extends MapController {
  apple_maps.AppleMapController childController;

  AppleMapController(this.childController);

  @override
  void moveCameraToPosition(CameraPosition position) {
    childController.animateCamera(apple_maps.CameraUpdate.newLatLngZoom(
        apple_maps.LatLng(position.latLng.latitude, position.latLng.longitude),
        position.zoom));
  }

  @override
  void moveCameraToBounds(LatLngBounds bounds, double padding) {
    childController.animateCamera(apple_maps.CameraUpdate.newLatLngBounds(
        apple_maps.LatLngBounds(
            northeast: apple_maps.LatLng(
                bounds.northEast.latitude, bounds.northEast.longitude),
            southwest: apple_maps.LatLng(
                bounds.southWest.latitude, bounds.southWest.longitude)),
        padding));
  }
}
