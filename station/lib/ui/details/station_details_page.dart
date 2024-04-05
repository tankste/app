import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/ui/preview/route_preview.dart';
import 'package:station/ui/details/cubit/station_details_cubit.dart';
import 'package:station/ui/details/cubit/station_details_state.dart';
import 'package:url_launcher/url_launcher.dart';
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
        Text(tr('generic.error.title'),
            style: Theme.of(context).textTheme.headline5),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              (tr('generic.error.long')),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            )),
        Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
                onPressed: () {
                  context.read<StationDetailsCubit>().onRetryClicked();
                },
                child: Text(tr('generic.retry.long')))),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(tr('generic.error.details.title')),
                      content: Text(state.errorDetails),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(tr('generic.ok'))),
                      ],
                    );
                  });
            },
            child: Text(tr('generic.error.details.show'))),
        Spacer(),
      ]));
    } else if (state is DetailStationDetailsState) {
      return RefreshIndicator(
          onRefresh: () {
            context.read<StationDetailsCubit>().onRefreshAction();
            return Future.value();
          },
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                    child: Text(tr('station.prices.title'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                  ),
                                  ...(state.prices
                                      .map((price) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(children: [
                                                  Text(price.fuel,
                                                      style: TextStyle(
                                                          fontWeight: price
                                                                  .isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal)),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8),
                                                      child: Image.network(
                                                          state
                                                              .openTimesOriginIconUrl,
                                                          height: 10))
                                                ]),
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: price.originalPrice != null
                                                      ? Text(
                                                          price.originalPrice ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight: price
                                                                      .isHighlighted
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal))
                                                      : Container()),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(price.homePrice,
                                                      style: TextStyle(
                                                          fontWeight: price
                                                                  .isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                            ],
                                          )))
                                      .toList()),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        tr('station.prices.last_price_changes_at',
                                            args: [state.lastPriceUpdate]),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
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
                                      child: Row(
                                        children: [
                                          Text(tr('station.open_times.title'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6),
                                          Padding(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Image.network(
                                                  state.openTimesOriginIconUrl,
                                                  height: 14))
                                        ],
                                      )),
                                  ...(state.openTimes
                                      .map((openTime) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(openTime.day,
                                                      style: TextStyle(
                                                          fontWeight: openTime
                                                                  .isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(openTime.time,
                                                      style: TextStyle(
                                                          fontWeight: openTime
                                                                  .isHighlighted
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal))),
                                            ],
                                          )))
                                      .toList()),
                                ]))),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 32, bottom: 16, left: 8, right: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(tr('station.data_source.title'),
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                              ),
                              ...(state.origins
                                  .map((origin) => InkWell(
                                      onTap: origin.websiteUrl != null
                                          ? () {
                                              _openUrl(origin.websiteUrl!);
                                            }
                                          : null,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 4, bottom: 4),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(origin.iconUrl,
                                                  height: 14),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Text(
                                                    origin.name,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ))
                                            ],
                                          ))))
                                  .toList()),
                            ]))
                  ]))));
    }

    return Container();
  }

  void _openUrl(String url) async {
    Uri uri = Uri.tryParse(url)!;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      //TODO: handle this case
//        throw 'Could not launch $url';
    }
  }
}
