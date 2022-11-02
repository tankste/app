import 'dart:typed_data';

import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

typedef MapCreatedCallback = void Function(MapController controller);
typedef CameraPositionCallback = void Function(CameraPosition cameraPosition);

//TODO: find better name
abstract class ChildMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback onMapCreated;
  final VoidCallback? onCameraIdle;
  final CameraPositionCallback? onCameraMove;
  final Set<Marker> markers;

  ChildMap(
      {required this.initialCameraPosition,
      required this.onMapCreated,
      this.onCameraIdle,
      this.onCameraMove,
      this.markers = const <Marker>{},
      Key? key})
      : super(key: key);
}

class CameraPosition {
  LatLng latLng;
  double zoom;

  CameraPosition({required this.latLng, required this.zoom});
}

class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);
}

abstract class MapController {
  void moveCamera(CameraPosition position);
}

class Marker {
  String id;
  LatLng latLng;
  ByteData icon; //TODO: Check if we can use better format here
  VoidCallback? onTap;

  Marker(
      {required this.id, required this.latLng, required this.icon, this.onTap});
}
