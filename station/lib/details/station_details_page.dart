import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/ui/preview/route_preview.dart';
import 'package:station/details/cubit/station_details_cubit.dart';
import 'package:station/details/cubit/station_details_state.dart';
import 'package:station/station_model.dart';

//TODO: extract duplicated layouts to functions / widgets
class StationDetailsPage extends StatelessWidget {
  final String stationId;
  final String? stationName;
  final String? activeGasPriceFilter;

  const StationDetailsPage(
      {required this.stationId,
      this.stationName,
      this.activeGasPriceFilter,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => StationDetailsCubit(stationId),
        child: BlocConsumer<StationDetailsCubit, StationDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(state.station?.label ?? stationName ?? ""),
                  ),
                  body: SafeArea(child: _buildBody(context, state)));
            }));
  }

  Widget _buildBody(BuildContext context, StationDetailsState state) {
    if (state.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == Status.failure) {
      return Center(
          child: Column(children: [
        Spacer(),
        Text("Fehler!", style: Theme.of(context).textTheme.headline5),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Es ist ein Fehler aufgetreten. Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
                onPressed: () {
                  context.read<StationDetailsCubit>().onRetryClicked();
                },
                child: const Text("Wiederholen"))),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Fehler Details'),
                      content: Text(state.error.toString()),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Ok')),
                      ],
                    );
                  });
            },
            child: const Text("Fehler anzeigen")),
        Spacer(),
      ]));
    }

    if (state.status == Status.success) {
      final StationModel station = state.station!;

      return SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                RoutePreview(
                    target: station.coordinate,
                    address:
                        "${station.address.street} ${station.address.houseNumber}\n${station.address.postCode} ${station.address.city}",
                    label: station.label),
                Card(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text("Spritpreise",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Super E5",
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "e5"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              _priceText(station.prices.e5,
                                                  station.isOpen),
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "e5"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Super E10",
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "e10"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              _priceText(station.prices.e10,
                                                  station.isOpen),
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "e10"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text("Diesel",
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "diesel"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                              _priceText(station.prices.diesel,
                                                  station.isOpen),
                                              style: TextStyle(
                                                  fontWeight:
                                                      activeGasPriceFilter ==
                                                              "diesel"
                                                          ? FontWeight.bold
                                                          : FontWeight
                                                              .normal))),
                                    ],
                                  ))
                            ]))),
                Card(
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text("Öffnungszeiten\u{002A}",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ),
                              ...(station.openTimes
                                  .map((openTime) => Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(openTime.label)),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  "${openTime.start} - ${openTime.end}")),
                                        ],
                                      )))
                                  .toList()),
                              Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                      "\u{002A}Die Öffnungszeiten können an gesetzlichen Feiertagen abweichen.",
                                      style:
                                          Theme.of(context).textTheme.caption))
                            ])))
              ])));
    }

    return Container();
  }

  String _priceText(double price, bool isOpen) {
    String priceText;
    if (!isOpen || price == 0) {
      priceText = "-,--\u{207B}";
    } else {
      priceText = price.toString().replaceAll('.', ',');
    }

    if (priceText.length == 5) {
      priceText = priceText
          .replaceFirst('0', '\u{2070}', 4)
          .replaceFirst('1', '\u{00B9}', 4)
          .replaceFirst('2', '\u{00B2}', 4)
          .replaceFirst('3', '\u{00B3}', 4)
          .replaceFirst('4', '\u{2074}', 4)
          .replaceFirst('5', '\u{2075}', 4)
          .replaceFirst('6', '\u{2076}', 4)
          .replaceFirst('7', '\u{2077}', 4)
          .replaceFirst('8', '\u{2078}', 4)
          .replaceFirst('9', '\u{2079}', 4);
    }

    return "$priceText €";
  }
}
