import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/map_models.dart';
import 'package:map/ui/generic_map.dart';
import 'package:settings/ui/settings/settings_page.dart';
import 'package:sponsor_ui/ui/item/membership_map_item.dart';
import 'package:station/ui/details/station_details_page.dart';
import 'package:station/ui/map/cubit/station_map_cubit.dart';
import 'package:station/ui/map/cubit/station_map_state.dart';
import 'package:station/ui/map/filter_dialog.dart';
import 'package:station/ui/price_format.dart';
import 'package:station/model/fuel_type.dart';

class StationMapPage extends StatefulWidget {
  const StationMapPage({super.key});

  @override
  State<StationMapPage> createState() => StationMapPageState();
}

class StationMapPageState extends State<StationMapPage> {
  final GlobalKey membershipItemKey = GlobalKey();
  MapController? _mapController;

  bool _showList = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StationMapCubit(),
      child: BlocConsumer<StationMapCubit, StationMapState>(
        listener: (context, state) {
          if (state is MoveToInitLoadingStationMapState) {
            _mapController?.moveCameraToPosition(state.cameraPosition);
          } else if (state is MoveToOwnLoadingStationMapState) {
            _mapController?.moveCameraToPosition(state.cameraPosition);
          } else if (state is MoveToZoomedInLoadingStationMapState) {
            _mapController?.moveCameraToPosition(state.cameraPosition);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                _buildViewSwitcher(),
                Expanded(
                  child: _buildBody(context, state, false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildViewSwitcher() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SegmentedButton<bool>(
          segments: const [
            ButtonSegment<bool>(
              value: false,
              label: Text('Karte'),
              icon: Icon(Icons.map),
            ),
            ButtonSegment<bool>(
              value: true,
              label: Text('Liste'),
              icon: Icon(Icons.list),
            ),
          ],
          selected: {_showList},
          onSelectionChanged: (selection) {
            setState(() {
              _showList = selection.first;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, StationMapState state, bool isLoading) {
    if (state is FindOwnPositionLoadingStationMapState) {
      return _buildBody(context, state.underlyingState, true);
    } else if (state is MoveToZoomedInLoadingStationMapState) {
      isLoading = true;
    } else if (state is LoadingMarkersStationMapState) {
      return _buildBody(context, state.underlyingState, true);
    } else if (state is LoadingStationMapState) {
      isLoading = true;
    }

    if (_showList && state is MarkersStationMapState) {
      return _buildStationList(context, state);
    }

    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).colorScheme.surface,
          child: GenericMap(
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (mapController) {
              setState(() {
                _mapController = mapController;
              });

              context.read<StationMapCubit>().onMapReady();
            },
            onCameraIdle: () {
              context.read<StationMapCubit>().onCameraIdle();
            },
            onCameraMove: (position) {
              if (_mapController == null) {
                return;
              }

              context
                  .read<StationMapCubit>()
                  .onCameraPositionChanged(position);
            },
            markers: state is MarkersStationMapState
                ? _genMarkers(context, state)
                : {},
          ),
        ),
        isLoading
            ? const SafeArea(child: LinearProgressIndicator())
            : Container(),
        Positioned(
          top: 8,
          left: 8,
          child: SafeArea(
            child: MembershipMapItem(key: membershipItemKey),
          ),
        ),
        state is TooFarZoomedOutStationMapState
            ? Positioned(
                top: 8,
                left: 80,
                right: 80,
                child: SafeArea(
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        context
                            .read<StationMapCubit>()
                            .onZoomInfoClicked();
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 14,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    tr('station.map.too_far_zoomed_out'),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        state is ErrorStationMapState
            ? Positioned(
                top: 8,
                left: 8,
                right: 80,
                child: SafeArea(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr('generic.error.title'),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              tr('generic.error.long'),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
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
                                          title: Text(
                                            tr('generic.error.details.title'),
                                          ),
                                          content:
                                              Text(state.errorDetails ?? ""),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(
                                                true,
                                              ),
                                              child: Text(tr('generic.ok')),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    tr('generic.error.details.show'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<StationMapCubit>()
                                          .onRetryClicked();
                                    },
                                    child: Text(
                                      tr('generic.retry.short'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
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
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Icon(
                          Icons.settings,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Divider(height: 1),
                    ),
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: !Platform.isIOS ? 8 : 32,
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
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        state is FilterDialogStationMapState
            ? FilterDialog(
                currentFilter: state.filter,
                onSubmit: (filter) {
                  context.read<StationMapCubit>().onFilterSaved(filter);
                },
                onCancel: () {
                  context
                      .read<StationMapCubit>()
                      .onCancelFilterSettings();
                },
              )
            : Container(),
      ],
    );
  }

  Widget _buildStationList(
    BuildContext context,
    MarkersStationMapState state,
  ) {
    final stations = List<MarkerAnnotation>.from(state.stationMarkers);

    stations.sort((a, b) {
      final priceA = _getPrice(a.marker, state.filter.gas);
      final priceB = _getPrice(b.marker, state.filter.gas);

      if (priceA == null && priceB == null) {
        return a.marker.label.compareTo(b.marker.label);
      }

      if (priceA == null) {
        return 1;
      }

      if (priceB == null) {
        return -1;
      }

      return priceA.compareTo(priceB);
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Text(
                '${stations.length} Tankstellen',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                'Preis',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
            itemCount: stations.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final annotation = stations[index];
              final marker = annotation.marker;
              final price = _getPrice(marker, state.filter.gas);

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    marker.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    price == null
                        ? 'Preis nicht verfügbar'
                        : _formatPrice(marker, price),
                  ),
                  trailing: price == null
                      ? null
                      : Text(
                          _formatPrice(marker, price),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StationDetailsPage(
                          stationId: marker.stationId,
                          markerLabel: marker.label,
                          activeGasPriceFilter: state.filter.gas,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  double? _getPrice(MarkerModel marker, String gas) {
    FuelType? fuelType;

    if (gas == "e5") {
      fuelType = FuelType.petrolSuperE5;
    } else if (gas == "e10") {
      fuelType = FuelType.petrolSuperE10;
    } else if (gas == "diesel") {
      fuelType = FuelType.diesel;
    }

    if (fuelType == null) {
      return null;
    }

    for (final markerPrice in marker.prices) {
      if (markerPrice.fuelType == fuelType &&
          markerPrice.state != PriceState.notAvailable &&
          markerPrice.state != PriceState.unknown) {
        return markerPrice.price;
      }
    }

    return null;
  }

  String _formatPrice(MarkerModel marker, double price) {
    return PriceFormat.format(
          marker.currency.convertTo(
                price,
                CurrencyType.euro,
              ) ??
              price,
          CurrencyModel.euro,
          false,
        ) ??
        '${price.toStringAsFixed(3)} €';
  }

  Set<Marker> _genMarkers(
    BuildContext context,
    MarkersStationMapState state,
  ) {
    List<Marker> markers = state.stationMarkers
        .map(
          (annotation) => Marker(
            id: annotation.id,
            latLng: LatLng(
              annotation.marker.coordinate.latitude,
              annotation.marker.coordinate.longitude,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StationDetailsPage(
                    stationId: annotation.marker.stationId,
                    markerLabel: annotation.marker.label,
                    activeGasPriceFilter: state.filter.gas,
                  ),
                ),
              );
            },
            icon: annotation.icon,
          ),
        )
        .toList();

    return markers.toSet();
  }
}