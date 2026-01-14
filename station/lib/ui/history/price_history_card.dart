import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/ui/history/cubit/price_history_cubit.dart';
import 'package:station/ui/history/cubit/price_history_state.dart';
import 'package:station/ui/price_format.dart';
import 'package:core/ui/expand_only.dart';

class PriceHistoryCard extends StatelessWidget {
  final int stationId;
  final String? activateGasPriceFilter;

  const PriceHistoryCard(
      {required this.stationId, this.activateGasPriceFilter, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            PriceHistoryCubit(stationId, activateGasPriceFilter),
        child: BlocConsumer<PriceHistoryCubit, PriceHistoryState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Card(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: Text(tr('station.price_history.title'),
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            ExpandOnly(child: _buildContent(context, state))
                          ])));
            }));
  }

  Widget _buildContent(BuildContext context, PriceHistoryState state) {
    if (state is LoadingPriceHistoryState) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ErrorPriceHistoryState) {
      return Column(children: [
        Text(
          tr('generic.error.short'),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ElevatedButton(
                onPressed: () {
                  context.read<PriceHistoryCubit>().onRetryClicked();
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
      ]);
    } else if (state is EmptyPriceHistoryState) {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: Text(tr('station.price_history.empty'))));
    } else if (state is DataPriceHistoryState) {
      return Column(children: [
        AspectRatio(
            aspectRatio: 2,
            child: LineChart(LineChartData(
                minY: state.priceMinChart,
                maxY: state.priceMaxChart,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) =>
                          _priceLegend(meta, value, state.currency),
                      interval: 0.05,
                      reservedSize: 48,
                      minIncluded: false,
                      maxIncluded: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) =>
                          _dateLegend(meta, value, state.selectedDays),
                      interval: null,
                      minIncluded: false,
                      maxIncluded: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: state.priceData
                        .map((d) => FlSpot(
                            d.date.millisecondsSinceEpoch.toDouble(), d.price))
                        .toList(growable: false),
                    isCurved: true,
                    barWidth: 3,
                    color: Theme.of(context).primaryColor,
                    dotData: const FlDotData(show: false),
                  ),
                ]))),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    spacing: 8,
                    children: state.availableFuelTypes
                        .map((fuelType) => ChoiceChip(
                            onSelected: (selected) {
                              context
                                  .read<PriceHistoryCubit>()
                                  .onFuelTypeSelected(fuelType.fuelType);
                            },
                            selected: state.selectedFuelType == fuelType.fuelType,
                            selectedColor: Theme.of(context).primaryColor,
                            label: Text(fuelType.label,
                                style: TextStyle(
                                    color: state.selectedFuelType == fuelType.fuelType
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface))))
                        .toList(growable: false)))),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(spacing: 8, children: [
              ChoiceChip(
                  onSelected: (selected) {
                    context.read<PriceHistoryCubit>().onDaysSelected(1);
                  },
                  selected: state.selectedDays == 1,
                  selectedColor: Theme.of(context).primaryColor,
                  label: Text(tr('station.price_history.date_range.day'),
                      style: TextStyle(
                          color: state.selectedDays == 1
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface))),
              ChoiceChip(
                  onSelected: (selected) {
                    context.read<PriceHistoryCubit>().onDaysSelected(7);
                  },
                  selected: state.selectedDays == 7,
                  selectedColor: Theme.of(context).primaryColor,
                  label: Text(tr('station.price_history.date_range.week'),
                      style: TextStyle(
                          color: state.selectedDays == 7
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface))),
              ChoiceChip(
                  onSelected: (selected) {
                    context.read<PriceHistoryCubit>().onDaysSelected(14);
                  },
                  selected: state.selectedDays == 14,
                  selectedColor: Theme.of(context).primaryColor,
                  label: Text(tr('station.price_history.date_range.two_weeks'),
                      style: TextStyle(
                          color: state.selectedDays == 14
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface))),
              ChoiceChip(
                  onSelected: (selected) {
                    context.read<PriceHistoryCubit>().onDaysSelected(30);
                  },
                  selected: state.selectedDays == 30,
                  selectedColor: Theme.of(context).primaryColor,
                  label: Text(tr('station.price_history.date_range.month'),
                      style: TextStyle(
                          color: state.selectedDays == 30
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).colorScheme.onSurface))),
            ]))
      ]);
    }

    return Container();
  }

  Widget _priceLegend(TitleMeta meta, double price, CurrencyModel currency) {
    return SideTitleWidget(
      meta: meta,
      child: Text(
        PriceFormat.format(price, currency, true),
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _dateLegend(TitleMeta meta, double milliseconds, int selectedDays) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(milliseconds.truncate());
    DateFormat dateFormat;
    if (selectedDays == 1) {
      dateFormat = DateFormat(tr('generic.date.time.format'));
    } else if (selectedDays == 7) {
      dateFormat = DateFormat(tr('generic.date.date.weekday'));
    } else {
      dateFormat = DateFormat(tr('generic.date.date.dayMonth'));
    }

    return SideTitleWidget(
      meta: meta,
      child: Text(
        dateFormat.format(date),
        style: TextStyle(fontSize: 10),
      ),
    );
  }
}
