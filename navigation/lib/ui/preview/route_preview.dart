import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:navigation/ui/preview/cubit/route_preview_cubit.dart';
import 'package:navigation/ui/preview/cubit/route_preview_state.dart';
import 'package:navigation/util.dart';

class RoutePreview extends StatelessWidget {
  final CoordinateModel target;
  final String address;
  final String? label;

  const RoutePreview(
      {required this.target, required this.address, this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RoutePreviewCubit(target),
        child: BlocConsumer<RoutePreviewCubit, RoutePreviewState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Stack(
                          children: <Widget>[
                            PreviewMap(
                              target: target,
                              routePoints: state.route?.routeCoordinates,
                            ),
                            // Workaround: clicking FAB over map is triggered twice on iOS
                            GestureDetector(
                                onTap: () {
                                  _openMap();
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width,
                                    height: 180)),
                            Positioned(
                                bottom: 8,
                                right: 8,
                                child: FloatingActionButton(
                                  mini: true,
                                  onPressed: () {
                                    _openMap();
                                  },
                                  child: const Icon(Icons.navigation),
                                ))
                          ],
                        )),
                    InkWell(
                        onTap: () {
                          _openMap();
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(flex: 2, child: Text(address)),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(state.formatDistance()),
                                          Text(state.formatTravelTime())
                                        ],
                                      ))
                                ]))),
                  ]));
            }));
  }

  void _openMap() async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
        coords: Coords(target.latitude, target.longitude), title: label ?? "");
  }
}

class PreviewMap extends StatefulWidget {
  final CoordinateModel target;
  final List<CoordinateModel>? routePoints;

  const PreviewMap(
      {super.key, required this.target, required this.routePoints});

  @override
  State<StatefulWidget> createState() => PreviewMapState();
}

class PreviewMapState extends State<PreviewMap> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    LatLngBounds? bounds = _boundsFromLatLngList(
        widget.routePoints?.map((e) => toLatLng(e)).toList() ?? []);
    if (bounds != null) {
      _mapController?.moveCamera(CameraUpdate.newLatLngBounds(bounds, 36));
    }

    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: toLatLng(widget.target), zoom: 13),
      polylines: _genPolylines(widget.routePoints),
      markers: _genMarkers(),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) {
        setState(() {
          _mapController = controller;
        });
      },
    );
  }

  Set<Polyline> _genPolylines(List<CoordinateModel>? routePoints) {
    if (routePoints == null) {
      return <Polyline>{};
    }

    return {
      Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints.map((e) => toLatLng(e)).toList(),
          color: Theme.of(context).primaryColor,
          width: 4)
    };
  }

  // Source: https://github.com/flutter/flutter/issues/36653#issuecomment-525288053
  LatLngBounds? _boundsFromLatLngList(List<LatLng> list) {
    if (list.isEmpty) {
      return null;
    }

    double x0 = list.first.latitude;
    double x1 = list.first.latitude;
    double y0 = list.first.longitude;
    double y1 = list.first.longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  Set<Marker> _genMarkers() {
    return {
      Marker(
          markerId: const MarkerId("target"),
          position: toLatLng(widget.target),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure))
    };
  }
}
