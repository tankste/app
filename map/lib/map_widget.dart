import 'dart:io';

import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/apple/apple_map_widget.dart';
import 'package:map/child_map.dart';
import 'package:map/cubit/map_cubit.dart';
import 'package:map/cubit/map_state.dart';
import 'package:map/google/google_map_widget.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';
import 'package:settings/developer/model/developer_settings_model.dart';

//
// //TODO: markers
// //TODO: taps
// //TODO: lines
// //TODO: light/dark
// //TODO: provider selection
// //  1. Check for map provider settings
// //  2. Check for OS
// //  3. Check for open source flag and use OSM if needed
// class MapWidget extends StatefulWidget {
//   CameraPosition initialCameraPosition;
//   final MapCreatedCallback onMapCreated;
//   final VoidCallback? onCameraIdle;
//   final CameraPositionCallback? onCameraMove;
//   final Set<Marker> markers;
//
//   MapWidget({required this.initialCameraPosition,
//     required this.onMapCreated,
//     this.onCameraIdle,
//     this.onCameraMove,
//     this.markers = const <Marker>{},
//     Key? key})
//       : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => FooState();
// }
//
// class FooState extends State<MapWidget> {
//
//   //TODO: Check for map provider settings
//   //TODO: check for open source flag and use OSM if needed
//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isAndroid) {
//       return GoogleMapWidget(
//         initialCameraPosition: widget.initialCameraPosition,
//         onMapCreated: widget.onMapCreated,
//         onCameraIdle: widget.onCameraIdle,
//         onCameraMove: widget.onCameraMove,
//         // markers: widget.markers,
//       );
//     } else if (Platform.isIOS) {
//       return AppleMapWidget(
//         initialCameraPosition: widget.initialCameraPosition,
//         onMapCreated: widget.onMapCreated,
//         onCameraIdle: widget.onCameraIdle,
//         onCameraMove: widget.onCameraMove,
//         // markers: widget.markers,
//       );
//     }
//
//     return Container();
//   }
//
//   Widget _buildGoogleMap() {
//     return Container();
//   }
//
//   Widget _buildAppleMap() {
//     return Container();
//   }
// }

//TODO: markers
//TODO: taps
//TODO: lines
//TODO: light/dark
//TODO: provider selection
//  1. Check for map provider settings
//  2. Check for OS
//  3. Check for open source flag and use OSM if needed
class MapWidget extends StatelessWidget {
  CameraPosition initialCameraPosition;
  final MapCreatedCallback onMapCreated;
  final VoidCallback? onCameraIdle;
  final CameraPositionCallback? onCameraMove;
  final Set<Marker> markers;

  MapWidget(
      {required this.initialCameraPosition,
      required this.onMapCreated,
      this.onCameraIdle,
      this.onCameraMove,
      this.markers = const <Marker>{},
      Key? key})
      : super(key: key);

  //TODO: Check for map provider settings
  //TODO: check for open source flag and use OSM if needed
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapCubit(),
        child: BlocConsumer<MapCubit, MapState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Container();
              }

              if (state.status == Status.failure) {
                return _buildHint(
                    "Apple Maps is only supported by iOS platforms.");
              }

              switch (state.mapProvider) {
                case MapProvider.google:
                  return _buildGoogleMap();
                case MapProvider.openStreet:
                  return _buildHint("OpenStreetMap is not implemented yet!");
                case MapProvider.apple:
                  return _buildAppleMap();
                default:
                  return _buildHint("Invalid state! No map provider given.");
              }
            }));
  }

  Widget _buildGoogleMap() {
    return Scaffold(
        body: GoogleMapWidget(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: onMapCreated,
      onCameraIdle: onCameraIdle,
      onCameraMove: onCameraMove,
      markers: markers,
    ));
  }

  Widget _buildAppleMap() {
    if (Platform.isIOS) {
      return Scaffold(
          body: AppleMapWidget(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: onMapCreated,
        onCameraIdle: onCameraIdle,
        onCameraMove: onCameraMove,
        markers: markers,
      ));
    } else {
      return _buildHint("AppleMaps is only supported by iOS platform.");
    }
  }

  Widget _buildHint(String text) {
    return Scaffold(body: Center(child: Text(text)));
  }
}
