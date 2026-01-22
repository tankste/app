import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/model/map_provider_model.dart';
import 'package:settings/ui/map/cubit/map_provider_item_cubit.dart';
import 'package:settings/ui/map/cubit/map_provider_item_state.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_cubit.dart';

class MapProviderItem extends StatelessWidget {
  const MapProviderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapProviderItemCubit(),
        child: BlocConsumer<MapProviderItemCubit, MapProviderItemState>(
            listener: (context, state) {
          if (state is SaveErrorMapProviderItemState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(tr('generic.error.short')),
            ));
          }
        }, builder: (context, state) {
          return _buildBody(context, state);
        }));
  }

  Widget _buildBody(BuildContext context, MapProviderItemState state) {
    if (state is LoadingMapProviderItemState) {
      return ListTile(
          minLeadingWidth: 10,
          leading: Icon(Icons.map),
          title: Text(tr('settings.app.map_provider.title')),
          subtitle: Text("..."));
    } else if (state is ErrorMapProviderItemState) {
      return ListTile(
          onTap: () {
            context.read<MapProviderItemCubit>().onRetryClicked();
          },
          minLeadingWidth: 10,
          leading: const Icon(Icons.map),
          title: Text(tr('settings.app.map_provider.title')),
          subtitle:
              Text(tr('settings.item_error')));
    } else if (state is ProvidersMapProviderItemState) {
      return ListTile(
          onTap: () {
            _showSelectionDialog(context, state);
          },
          minLeadingWidth: 10,
          leading: const Icon(Icons.map),
          title: Text(tr('settings.app.map_provider.title')),
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
              title: Text(tr('settings.app.map_provider.title')),
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
                              child: Text(tr('generic.cancel')))
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
