import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple_maps;
import 'package:map/child_map.dart';

class AppleMapWidget extends ChildMap {
  AppleMapWidget(
      {required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AppleMapWidgetState();
}

class AppleMapWidgetState extends State<AppleMapWidget> {
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
      myLocationButtonEnabled: false,
      compassEnabled: false,
      myLocationEnabled: true,
    );
  }

  @override
  void didUpdateWidget(AppleMapWidget oldWidget) {
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
            icon: apple_maps.BitmapDescriptor.fromBytes(
                m.icon.buffer.asUint8List()),
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
  void moveCamera(CameraPosition position) {
    childController.animateCamera(apple_maps.CameraUpdate.newLatLngZoom(
        apple_maps.LatLng(position.latLng.latitude, position.latLng.longitude),
        position.zoom));
  }
}
