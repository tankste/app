import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map/apple/apple_map_widget.dart';
import 'package:map/child_map.dart';
import 'package:map/google/google_map_widget.dart';
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
    if (Platform.isAndroid) {
      return GoogleMapWidget(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: onMapCreated,
        onCameraIdle: onCameraIdle,
        onCameraMove: onCameraMove,
        markers: markers,
      );
    } else if (Platform.isIOS) {
      return AppleMapWidget(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: onMapCreated,
        onCameraIdle: onCameraIdle,
        onCameraMove: onCameraMove,
        markers: markers,
      );
    }

    return Container();
  }

  Widget _buildGoogleMap() {
    return Container();
  }

  Widget _buildAppleMap() {
    return Container();
  }
}
