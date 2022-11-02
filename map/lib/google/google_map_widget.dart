import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:map/child_map.dart';

class GoogleMapWidget extends ChildMap {
  GoogleMapWidget(
      {required super.initialCameraPosition,
      required super.onMapCreated,
      super.onCameraIdle,
      super.onCameraMove,
      super.markers,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => GoogleMapWidgetState();
}

class GoogleMapWidgetState extends State<GoogleMapWidget> {
  Set<String> _markerIds = <String>{};
  Set<google_maps.Marker> _markers = <google_maps.Marker>{};

  @override
  Widget build(BuildContext context) {
    _mapMarkers();

    return google_maps.GoogleMap(
      initialCameraPosition: google_maps.CameraPosition(
          target: google_maps.LatLng(
              widget.initialCameraPosition.latLng.latitude,
              widget.initialCameraPosition.latLng.longitude),
          zoom: widget.initialCameraPosition.zoom),
      onMapCreated: (mapController) =>
          widget.onMapCreated(GoogleMapController(mapController)),
      onCameraIdle: () => widget.onCameraIdle?.call(),
      onCameraMove: (position) => widget.onCameraMove?.call(CameraPosition(
          latLng: LatLng(position.target.latitude, position.target.longitude),
          zoom: position.zoom)),
      markers: _markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
    );
  }

  Future _mapMarkers() async {
    Set<String> markerIds = widget.markers.map((m) => m.id).toSet();

    // Update markers only on changes
    if (_markerIds.difference(markerIds).isEmpty &&
        markerIds.difference(_markerIds).isEmpty) {
      return;
    }
    _markerIds = markerIds;

    Set<google_maps.Marker> markers = widget.markers
        .map((m) => google_maps.Marker(
            markerId: google_maps.MarkerId(m.id),
            icon: google_maps.BitmapDescriptor.fromBytes(
                m.icon.buffer.asUint8List()),
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
  void moveCamera(CameraPosition position) {
    childController.animateCamera(google_maps.CameraUpdate.newLatLngZoom(
        google_maps.LatLng(position.latLng.latitude, position.latLng.longitude),
        position.zoom));
  }
}
