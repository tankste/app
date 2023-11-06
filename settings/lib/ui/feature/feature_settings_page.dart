import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/feature/cubit/feature_settings_cubit.dart';
import 'package:settings/ui/feature/cubit/feature_settings_state.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/custom_switch_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class FeatureSettingsPage extends StatelessWidget {
  const FeatureSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Experimentelle Funktionen"),
        ),
        body: SafeArea(child: _buildBody(context)));
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
        create: (context) => FeatureSettingsCubit(),
        child: BlocConsumer<FeatureSettingsCubit, FeatureSettingsState>(
            listener: (context, state) {},
            builder: (context, state) {
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
                            context
                                .read<FeatureSettingsCubit>()
                                .onRetryClicked();
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
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Ok')),
                                ],
                              );
                            });
                      },
                      child: const Text("Fehler anzeigen")),
                  Spacer(),
                ]));
              }

              final List<Widget> items = _buildItems(context, state);
              return ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  return items[index];
                },
              );
            }));
  }

  List<Widget> _buildItems(BuildContext context, FeatureSettingsState state) {
    return [
      SettingsCard(title: "Allgemein", items: [
        CustomSwitchListTile(
          value: state.isFetchingWithoutLocationSelected ?? false,
          onChanged: (value) {
            context
                .read<FeatureSettingsCubit>()
                .onFetchWithoutLocationChanged(value);
          },
          minLeadingWidth: 8,
          secondary: const Icon(Icons.gps_off),
          title: const Text("Daten ohne Standort"),
          subtitle: const Text(
              "Tankstellen außerhalb des eigenen Standortes anzeigen. #6"),
          isThreeLine: true,
        ),
        CustomSwitchListTile(
          value: state.isPercentagePriceRangesSelected ?? false,
          onChanged: (value) {
            context
                .read<FeatureSettingsCubit>()
                .onPercentagePriceRangesEnabled(value);
          },
          minLeadingWidth: 8,
          secondary: const Icon(Icons.traffic),
          title: const Text("Prozentuale Preisberechnung"),
          subtitle: const Text("Preis-Farben prozentual berechnen. #28"),
          isThreeLine: true,
        ),
      ])
    ];
  }
}
