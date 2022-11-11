import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/generic/generic_map.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:navigation/ui/preview/cubit/route_preview_cubit.dart';
import 'package:navigation/ui/preview/cubit/route_preview_state.dart';
import 'package:navigation/util.dart';
import 'package:settings/map/repository/map_destination_repository.dart';
import 'package:settings/map/usecase/get_map_destination_use_case.dart';
import 'package:url_launcher/url_launcher.dart';

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
    //TODO: where to locate this, cubit? usecase? split logic to use case & cubit?!
    // Hacky solution with use case and type mapping here
    GetMapDestinationUseCase getUseCase =
        GetMapDestinationUseCaseImpl(LocalMapDestinationRepository());

    final availableMaps = await MapLauncher.installedMaps;
    final destinationMap = await getUseCase.invoke();

    final mapToLaunch = availableMaps
        .where((m) =>
            m.mapType ==
            //XXX
            LocalMapDestinationRepository()
                .destinationToType(destinationMap.destination))
        .firstOrNull;

    if (mapToLaunch != null) {
      mapToLaunch.showMarker(
          coords: Coords(target.latitude, target.longitude),
          title: label ?? "Tankstelle");
    } else if (Platform.isAndroid) {
      Uri androidUri = Uri.parse(
          "geo:${target.latitude},${target.longitude}?q=${target.latitude},${target.longitude} (${label ?? "Tankstelle"})");
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri);
      }
    } else if (Platform.isIOS) {
      MapLauncher.showMarker(
          mapType: MapType.apple,
          coords: Coords(target.latitude, target.longitude),
          title: label ?? "Tankstelle");
    }
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
  MapController? _mapController;

  @override
  Widget build(BuildContext context) {
    LatLngBounds? bounds = _boundsFromLatLngList(
        widget.routePoints?.map((e) => toLatLng(e)).toList() ?? []);
    if (bounds != null) {
      _mapController?.moveCameraToBounds(bounds, 36);
    }

    return GenericMap(
      initialCameraPosition:
          CameraPosition(latLng: toLatLng(widget.target), zoom: 13),
      polylines: _genPolylines(widget.routePoints),
      markers: _genMarkers(),
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
          id: "route",
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
    return LatLngBounds(northEast: LatLng(x1, y1), southWest: LatLng(x0, y0));
  }

  Set<Marker> _genMarkers() {
    return {Marker(id: "target", latLng: toLatLng(widget.target), icon: null)};
  }
}
