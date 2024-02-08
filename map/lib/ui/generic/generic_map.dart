import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/ui/apple/apple_map_widget.dart';
import 'package:map/ui/google/google_map_adapter.dart';
import 'package:map/ui/generic/map_adapter.dart';
import 'package:map/ui/maplibre/map_libre_map_adapter.dart';
import 'package:map/ui/cubit/map_cubit.dart';
import 'package:map/ui/cubit/map_state.dart';

class GenericMap extends StatelessWidget {
  final CameraPosition initialCameraPosition;
  final MapCreatedCallback onMapCreated;
  final VoidCallback? onCameraIdle;
  final CameraPositionCallback? onCameraMove;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const GenericMap(
      {required this.initialCameraPosition,
      required this.onMapCreated,
      this.onCameraIdle,
      this.onCameraMove,
      this.markers = const <Marker>{},
      this.polylines = const <Polyline>{},
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapCubit(),
        child: BlocConsumer<MapCubit, MapState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingMapState) {
                return Container();
              } else if (state is ErrorMapState) {
                return _buildHint(state.errorDetails);
              } else if (state is MapLibreMapState) {
                return _buildMapLibreMap(state);
              } else if (state is GoogleMapMapState) {
                return _buildGoogleMap();
              } else if (state is AppleMapsMapState) {
                return _buildAppleMap();
              } else {
                return _buildHint("Invalid state! No map provider given.");
              }
            }));
  }

  Widget _buildGoogleMap() {
    return Scaffold(
        body: GoogleMapAdapter(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            onCameraIdle: onCameraIdle,
            onCameraMove: onCameraMove,
            markers: markers,
            polylines: polylines));
  }

  Widget _buildMapLibreMap(MapLibreMapState state) {
    return Scaffold(
        body: MapLibreMapAdapter(
            styleUrlLight: state.styleUrlLight,
            styleUrlDark: state.styleUrlDark,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            onCameraIdle: onCameraIdle,
            onCameraMove: onCameraMove,
            markers: markers,
            polylines: polylines));
  }

  Widget _buildAppleMap() {
    if (Platform.isIOS) {
      return Scaffold(
          body: AppleMapAdapter(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: onMapCreated,
              onCameraIdle: onCameraIdle,
              onCameraMove: onCameraMove,
              markers: markers,
              polylines: polylines));
    } else {
      return _buildHint("AppleMaps is only supported by iOS platform.");
    }
  }

  Widget _buildHint(String text) {
    return Scaffold(body: Center(child: Text(text)));
  }
}

class CameraPosition {
  LatLng latLng;
  double zoom;

  CameraPosition({required this.latLng, required this.zoom});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CameraPosition &&
        other.latLng == latLng &&
        other.zoom == zoom;
  }

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LatLng &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

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
