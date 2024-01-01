import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/ui/preview/route_preview.dart';
import 'package:station/ui/details/cubit/station_details_cubit.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:report/ui/form/report_form_page.dart';

//TODO: extract duplicated layouts to functions / widgets
//TODO: make price highlighting work again
class StationDetailsPage extends StatelessWidget {
  final int stationId;
  final String? markerLabel;
  final String? activeGasPriceFilter;

  const StationDetailsPage(
      {required this.stationId,
      this.markerLabel,
      this.activeGasPriceFilter,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => StationDetailsCubit(
            stationId, markerLabel ?? "", activeGasPriceFilter ?? ""),
        child: BlocConsumer<StationDetailsCubit, StationDetailsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(state.title),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportFormPage(
                                        stationId: this.stationId)));
                          },
                          icon: Icon(Icons.report))
                    ],
                  ),
                  body: SafeArea(child: _buildBody(context, state)));
            }));
  }

  Widget _buildBody(BuildContext context, StationDetailsState state) {
    if (state is LoadingStationDetailsState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ErrorStationDetailsState) {
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
                      content: Text(state.errorDetails),
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
    } else if (state is DetailStationDetailsState) {
      return SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                RoutePreview(
                    target: state.coordinate,
                    address: state.address,
                    label: state.title),
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
                              ...(state.prices
                                  .map((price) => Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(price.fuel,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          price.isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                          Expanded(
                                              flex: 1,
                                              child: Text(price.price,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          price.isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                        ],
                                      )))
                                  .toList()),
                              Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(
                                    "Letzte Preisänderung: ${state.lastPriceUpdate}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
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
                                child: Text("Öffnungszeiten",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ),
                              ...(state.openTimes
                                  .map((openTime) => Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(openTime.day,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          openTime.isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                          Expanded(
                                              flex: 1,
                                              child: Text(openTime.time,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          openTime.isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                        ],
                                      )))
                                  .toList()),
                            ])))
              ])));
    }

    return Container();
  }
}
