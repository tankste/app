import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/ui/generic/generic_map.dart';
import 'package:settings/ui/settings/settings_page.dart';
import 'package:station/ui/details/station_details_page.dart';
import 'package:station/ui/map/cubit/station_map_cubit.dart';
import 'package:station/ui/map/cubit/station_map_state.dart';
import 'package:station/ui/map/filter_dialog.dart';

class StationMapPage extends StatelessWidget {
  MapController? _mapController;

  StationMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => StationMapCubit(),
        child: BlocConsumer<StationMapCubit, StationMapState>(
            listener: (context, state) {
          _mapController?.moveCameraToPosition(state.cameraPosition);
        }, builder: (context, state) {
          return Scaffold(body: _buildBody(context, state));
        }));
  }

  Widget _buildBody(BuildContext context, StationMapState state) {
    return Stack(children: <Widget>[
      GenericMap(
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (mapController) {
          mapController.moveCameraToPosition(state.cameraPosition);
          _mapController = mapController;
        },
        onCameraIdle: () {
          context.read<StationMapCubit>().onCameraIdle();
        },
        onCameraMove: (position) {
          context.read<StationMapCubit>().onCameraPositionChanged(position);
        },
        markers:
            state is MarkersStationMapState ? _genMarkers(context, state) : {},
      ),
      state is LoadingStationMapState || state is LoadingMarkersStationMapState
          ? const SafeArea(child: LinearProgressIndicator())
          : Container(),
      state is ErrorStationMapState
          ? Positioned(
              top: 8,
              left: 8,
              right: 80,
              child: SafeArea(
                  child: Card(
                      child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Unerwarteter Fehler",
                        style: Theme.of(context).textTheme.headline6),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                            "Es ist ein Fehler aufgetreten. Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
                            style: Theme.of(context).textTheme.bodyText2)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Fehler Details'),
                                        content: Text(state.errorDetails ?? ""),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text('Ok')),
                                        ],
                                      );
                                    });
                              },
                              child: const Text("Fehler anzeigen")),
                          Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<StationMapCubit>()
                                        .onRetryClicked();
                                  },
                                  child: const Text("Wiederholen")))
                        ],
                      ),
                    )
                  ],
                ),
              ))))
          : Container(),
      Positioned(
          top: 8,
          right: 8,
          child: SafeArea(
              child: SizedBox(
                  width: 64,
                  child: Card(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsPage()));
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.settings,
                                color: Theme.of(context).primaryColor,
                              ))),
                      const Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Divider(height: 1)),
                      InkWell(
                          onTap: () {
                            context
                                .read<StationMapCubit>()
                                .onMoveToLocationClicked();
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.gps_fixed,
                                color: Theme.of(context).primaryColor,
                              ))),
                    ],
                  ))))),
      Positioned(
          bottom: !Platform.isIOS ? 8 : 32,
          // Need more padding to keep "legal" link visible
          right: 8,
          child: SafeArea(
              child: SizedBox(
                  width: 64,
                  child: Card(
                      child: InkWell(
                          onTap: () {
                            context.read<StationMapCubit>().onFilterClicked();
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.tune,
                                color: Theme.of(context).primaryColor,
                              ))))))),
      state is FilterMarkersStationMapState
          ? FilterDialog(
              currentFilter: state.filter,
              onSubmit: (filter) {
                context.read<StationMapCubit>().onFilterSaved(filter);
              },
              onCancel: () {
                context.read<StationMapCubit>().onCancelFilterSettings();
              })
          : Container()
    ]);
  }

  Set<Marker> _genMarkers(BuildContext context, MarkersStationMapState state) {
    List<Marker> markers = state.stationMarkers.entries
        .map((entry) => Marker(
            id:
                "${entry.key.id}#${Object.hash(entry.key.e5Price, entry.key.e5PriceState, entry.key.e10Price, entry.key.e10PriceState, entry.key.dieselPrice, entry.key.dieselPriceState, state.isShowingLabelMarkers ? "label" : "dot")}",
            latLng: LatLng(
                entry.key.coordinate.latitude, entry.key.coordinate.longitude),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StationDetailsPage(
                            stationId: entry.key.id,
                            markerLabel: entry.key.label,
                            activeGasPriceFilter: state.filter.gas,
                          )));
            },
            icon: entry.value))
        .toList();
    return markers.toSet();
  }
}
