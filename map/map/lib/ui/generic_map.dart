import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/ui/cubit/map_cubit.dart';
import 'package:map/ui/cubit/map_state.dart';
import 'package:map_maplibre/ui/maplibre_map_adapter.dart';
import 'package:map_google/ui/google_map_adapter.dart';
import 'package:map_apple/ui/apple_map_adapter.dart';
import 'package:map_core/map_models.dart';
import 'package:map_core/ui/map_adapter.dart';

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
      super.key});

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
    return Scaffold(
        body: AppleMapAdapter(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: onMapCreated,
            onCameraIdle: onCameraIdle,
            onCameraMove: onCameraMove,
            markers: markers,
            polylines: polylines));
  }

  Widget _buildHint(String text) {
    return Scaffold(body: Center(child: Text(text)));
  }
}
