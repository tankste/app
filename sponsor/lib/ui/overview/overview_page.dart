import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return Column(children: [
        SfRadialGauge(
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
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 22,
                      endValue: 30,
                      startWidth: 15,
                      endWidth: 17.5,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 32,
                      endValue: 40,
                      startWidth: 17.5,
                      endWidth: 20,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 42,
                      endValue: 50,
                      startWidth: 20,
                      endWidth: 22.5,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 52,
                      endValue: 60,
                      startWidth: 22.5,
                      endWidth: 25,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 62,
                      endValue: 70,
                      startWidth: 25,
                      endWidth: 27.5,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 72,
                      endValue: 80,
                      startWidth: 27.5,
                      endWidth: 30,
                      color: Theme.of(context).primaryColor),
                  GaugeRange(
                      startValue: 82,
                      endValue: 90,
                      startWidth: 30,
                      endWidth: 32.5,
                      color: Theme.of(context).primaryColor),
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
                      knobStyle:
                          KnobStyle(color: Colors.black, knobRadius: 0.09))
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Container(
                          width: 30.00,
                          height: 30.00,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: ExactAssetImage('images/fuel.jpg'),
                              fit: BoxFit.fill,
                            ),
                          )),
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
        ),
      ]);
    } else {
      return Container();
    }
  }
}
