import 'dart:ui';

import 'package:flutter/foundation.dart';


class CameraPosition {
  LatLng latLng;
  double zoom;

  CameraPosition({required this.latLng, required this.zoom});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraPosition &&
          runtimeType == other.runtimeType &&
          latLng == other.latLng &&
          zoom == other.zoom;

  @override
  int get hashCode => latLng.hashCode ^ zoom.hashCode;

  @override
  String toString() {
    return 'CameraPosition{latLng: $latLng, zoom: $zoom}';
  }
}

class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }
}

class LatLngBounds {
  final LatLng northEast;
  final LatLng southWest;

  LatLngBounds({required this.northEast, required this.southWest});

  @override
  String toString() {
    return 'LatLngBounds{northEast: $northEast, southWest: $southWest}';
  }
}

abstract class MapController {
  void moveCameraToPosition(CameraPosition position);

  void moveCameraToBounds(LatLngBounds bounds, double padding);
}

class Marker {
  String id;
  LatLng latLng;
  ByteData? icon; //TODO: Check if we can use better format here
  VoidCallback? onTap;

  Marker(
      {required this.id, required this.latLng, required this.icon, this.onTap});

  Marker withoutIcon() {
    return Marker(id: id, latLng: latLng, icon: null, onTap: onTap);
  }

  @override
  String toString() {
    return 'Marker{id: $id, latLng: $latLng, icon: $icon, onTap: $onTap}';
  }
}

class Polyline {
  String id;
  List<LatLng> points;
  Color color;
  int width;

  Polyline(
      {required this.id,
      required this.points,
      required this.color,
      required this.width});

  @override
  String toString() {
    return 'Polyline{id: $id, points: $points, color: $color, width: $width}';
  }
}
