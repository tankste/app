import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/map_destination_model.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_cubit.dart';
import 'package:settings/ui/navigation/cubit/map_destination_item_state.dart';
import 'package:settings/ui/navigation/map_destination_selection_dialog.dart';

class MapDestinationItem extends StatelessWidget {
  const MapDestinationItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MapDestinationItemCubit(),
        child: BlocConsumer<MapDestinationItemCubit, MapDestinationItemState>(
            listener: (context, state) {},
            builder: (context, state) {
              return ListTile(
                  onTap: () {
                    _showSelectionDialog(
                        context,
                        state.availableDestinations ??
                            [
                              MapDestinationModel("Systemstandard",
                                  MapDestinationDestination.system)
                            ],
                        state.value ?? MapDestinationDestination.system);
                  },
                  minLeadingWidth: 10,
                  leading: const Icon(Icons.navigation),
                  title: const Text("Navigation starten mit.."),
                  subtitle: Text(state.valueLabel ?? ""));
            }));
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
