import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/map_destination_model.dart';
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
            listener: (context, state) {},
            builder: (context, state) {
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
            // _showSelectionDialog(
            //     context,
            //     state.availableDestinations ??
            //         [
            //           MapDestinationModel("Systemstandard",
            //               MapDestinationDestination.system)
            //         ],
            //     state.value ?? MapDestinationDestination.system);
          },
          minLeadingWidth: 10,
          leading: const Icon(Icons.map),
          title: const Text("Kartenanbieter"),
          subtitle: Text(state.selectedProvider));
    }

    return Container();
  }

  void _showSelectionDialog(BuildContext context,
      List<MapDestinationModel> availableMaps, MapDestinationDestination map) {
    showDialog(
        context: context,
        builder: (context) {
          return MapDestinationSelectionDialog(
              availableMaps: availableMaps, selection: map);
        }).then((map) {
      if (map != null) {
        context.read<MapDestinationItemCubit>().onMapChanged(map);
      }
    });
  }
}
