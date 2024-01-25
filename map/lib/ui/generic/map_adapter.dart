import 'package:flutter/material.dart';
import 'package:map/ui/generic/generic_map.dart';

typedef MapCreatedCallback = void Function(MapController controller);
typedef CameraPositionCallback = void Function(CameraPosition cameraPosition, LatLngBounds visibleBounds);

abstract class MapAdapter extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback onMapCreated;
  final VoidCallback? onCameraIdle;
  final CameraPositionCallback? onCameraMove;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const MapAdapter(
      {required this.initialCameraPosition,
      required this.onMapCreated,
      this.onCameraIdle,
      this.onCameraMove,
      this.markers = const <Marker>{},
      this.polylines = const <Polyline>{},
      Key? key})
      : super(key: key);
}
