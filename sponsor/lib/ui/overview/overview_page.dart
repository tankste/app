import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor/ui/offer/offer_container.dart';
import 'package:sponsor/ui/overview/cubit/overview_cubit.dart';
import 'package:sponsor/ui/overview/cubit/overview_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

//TODO: extract duplicated layouts to functions / widgets
class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OverviewCubit(),
        child: BlocConsumer<OverviewCubit, OverviewState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text("Spenden"),
                  ),
                  body: SafeArea(child: _buildBody(context, state)));
            }));
  }

  Widget _buildBody(BuildContext context, OverviewState state) {
    if (state is LoadingOverviewState) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ErrorOverviewState) {
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
                  context.read<OverviewCubit>().onRetryClicked();
                },
                child: const Text("Wiederholen"))),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Fehler Details'),
                      content: Text(state.errorDetails.toString()),
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
    } else if (state is BalanceOverviewState) {
      return SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
            Container(
                height: 240,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                        startAngle: 180,
                        endAngle: 0,
                        showTicks: false,
                        showAxisLine: false,
                        showLabels: false,
                        canScaleToFit: true,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0,
                              endValue: 10,
                              startWidth: 10,
                              endWidth: 12.5,
                              color: Colors.red),
                          GaugeRange(
                              startValue: 12,
                              endValue: 20,
                              startWidth: 12.5,
                              endWidth: 15,
                              color: Color(0xFFdecbe3)),
                          GaugeRange(
                              startValue: 22,
                              endValue: 30,
                              startWidth: 15,
                              endWidth: 17.5,
                              color: Color(0xFFd3bada)),
                          GaugeRange(
                              startValue: 32,
                              endValue: 40,
                              startWidth: 17.5,
                              endWidth: 20,
                              color: Color(0xFFc8a9d1)),
                          GaugeRange(
                              startValue: 42,
                              endValue: 50,
                              startWidth: 20,
                              endWidth: 22.5,
                              color: Color(0xFFbd97c8)),
                          GaugeRange(
                              startValue: 52,
                              endValue: 60,
                              startWidth: 22.5,
                              endWidth: 25,
                              color: Color(0xFFb286bf)),
                          GaugeRange(
                              startValue: 62,
                              endValue: 70,
                              startWidth: 25,
                              endWidth: 27.5,
                              color: Color(0xFFa775b6)),
                          GaugeRange(
                              startValue: 72,
                              endValue: 80,
                              startWidth: 27.5,
                              endWidth: 30,
                              color: Color(0xFF9c64ad)),
                          GaugeRange(
                              startValue: 82,
                              endValue: 90,
                              startWidth: 30,
                              endWidth: 32.5,
                              color: Color(0xFF9253a4)),
                          GaugeRange(
                              startValue: 92,
                              endValue: 100,
                              startWidth: 32.5,
                              endWidth: 35,
                              color: Theme.of(context).primaryColor)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                              value: state.gaugePercentage.toDouble(),
                              needleEndWidth: 7,
                              needleStartWidth: 1,
                              needleColor: Colors.red,
                              needleLength: 0.75,
                              knobStyle: KnobStyle(
                                  color: Colors.black, knobRadius: 0.09))
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Image.asset(
                                color: Theme.of(context).primaryColor,
                                'assets/images/logo_foreground.png',
                                package: 'core',
                                width: 30,
                                height: 30,
                              ),
                              angle: 270,
                              positionFactor: 0.35),
                          GaugeAnnotation(
                              widget: Text(
                                'E',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times'),
                              ),
                              angle: 175,
                              positionFactor: 1),
                          GaugeAnnotation(
                              widget: Text(
                                'F',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Times'),
                              ),
                              angle: 5,
                              positionFactor: 0.95),
                        ])
                  ],
                )),
            Center(
                child: Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Text(state.balance,
                        style: Theme.of(context).textTheme.bodySmall))),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text("tankste! braucht dich!",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, left: 16, right: 16),
              child: Text(
                  "Um die laufenden Kosten zu decken, bin ich auf eure finazielle Hilfe angewiesen.\nDu sparst mit tankste! regelmäßig Geld beim Tanken? Dann überlass dem Projekt doch einen kleinen Betrag davon.\nSo bleibt die App auch in Zukunft werbefrei!",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            OfferContainer(),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text("Sponsoren",
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(child: Text("F")),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Fabi755",
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text("Tolle App!! Danke!",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ))),
                    Text("25 €", style: Theme.of(context).textTheme.bodyLarge)
                  ],
                )),
            Center(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        "Danke an jede/n einzelnen Unterstützer/in! 💜💜💜💜",
                        style: Theme.of(context).textTheme.bodySmall))),
          ]));
    } else {
      return Container();
    }
  }
}
