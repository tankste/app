import 'package:flutter/material.dart';
import 'package:map_core/ui/map_adapter.dart';

class AppleMapAdapter extends MapAdapter {
  const AppleMapAdapter({
    required super.initialCameraPosition,
    required super.onMapCreated,
    super.onCameraIdle,
    super.onCameraMove,
    super.markers,
    super.polylines,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => AppleMapAdapterState();
}

class AppleMapAdapterState extends State<AppleMapAdapter> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
