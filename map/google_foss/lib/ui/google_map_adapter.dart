import 'package:flutter/material.dart';
import 'package:map_core/ui/map_adapter.dart';

class GoogleMapAdapter extends MapAdapter {
  const GoogleMapAdapter({
    required super.initialCameraPosition,
    required super.onMapCreated,
    super.onCameraIdle,
    super.onCameraMove,
    super.markers,
    super.polylines,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => GoogleMapAdapterState();
}

class GoogleMapAdapterState extends State<GoogleMapAdapter> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
