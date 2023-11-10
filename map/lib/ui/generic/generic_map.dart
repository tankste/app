import 'dart:io';

import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/ui/apple/apple_map_widget.dart';
import 'package:map/ui/google/google_map_adapter.dart';
import 'package:map/ui/generic/map_adapter.dart';
import 'package:map/ui/maplibre/map_libre_map_adapter.dart';
import 'package:map/ui/osm/open_street_map_adapter.dart';
import 'package:map/cubit/map_cubit.dart';
import 'package:map/cubit/map_state.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';

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
}

class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);
}

class LatLngBounds {
  final LatLng northEast;
  final LatLng southWest;

  LatLngBounds({required this.northEast, required this.southWest});
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
}
