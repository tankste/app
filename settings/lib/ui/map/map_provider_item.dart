import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/map_destination_model.dart';
import 'package:settings/model/map_provider_model.dart';
import 'package:settings/ui/map/cubit/map_provider_item_cubit.dart';
import 'package:settings/ui/map/cubit/map_provider_item_state.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_cubit.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_state.dart';
import 'package:settings/ui/navigation/map_destination_selection_dialog.dart';

class MapProviderItem extends StatelessWidget {
  const MapProviderItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapProviderItemCubit(),
        child: BlocConsumer<MapProviderItemCubit, MapProviderItemState>(
            listener: (context, state) {
          if (state is SaveErrorMapProviderItemState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Ein Fehler ist aufgetreten"),
            ));
          }
        }, builder: (context, state) {
          return _buildBody(context, state);
        }));
  }

  Widget _buildBody(BuildContext context, MapProviderItemState state) {
    if (state is LoadingMapProviderItemState) {
      return const ListTile(
          minLeadingWidth: 10,
          leading: Icon(Icons.map),
          title: Text("Kartenanbieter"),
          subtitle: Text("..."));
    } else if (state is ErrorMapProviderItemState) {
      return ListTile(
          onTap: () {
            context.read<MapProviderItemCubit>().onRetryClicked();
          },
          minLeadingWidth: 10,
          leading: const Icon(Icons.map),
          title: const Text("Kartenanbieter"),
          subtitle:
              Text("Es ist ein Fehler aufgetreten! Zum Wiederholen klicken."));
    } else if (state is ProvidersMapProviderItemState) {
      return ListTile(
          onTap: () {
            _showSelectionDialog(context, state);
          },
          minLeadingWidth: 10,
          leading: const Icon(Icons.map),
          title: const Text("Kartenanbieter"),
          subtitle: Text(state.selectedProvider.item2));
    }

    return Container();
  }

  void _showSelectionDialog(
      BuildContext context, ProvidersMapProviderItemState state) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
              title: const Text("Kartenanbieter"),
              children: state.availableProviders.entries
                      .map<Widget>((provider) => RadioListTile<MapProvider>(
                            title: Text(provider.value),
                            value: provider.key,
                            selected:
                                provider.key == state.selectedProvider.item1,
                            groupValue: state.selectedProvider.item1,
                            onChanged: (_) {
                              context
                                  .read<MapProviderItemCubit>()
                                  .onProviderChanged(provider.key);

                              Navigator.of(context).pop();
                            },
                          ))
                      .toList() +
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(null),
                              child: const Text('Abbrechen'))
                        ],
                      ),
                    )
                  ]);
        }).then((map) {
      if (map != null) {
        context.read<MapDestinationItemCubit>().onMapChanged(map);
      }
    });
  }
}
