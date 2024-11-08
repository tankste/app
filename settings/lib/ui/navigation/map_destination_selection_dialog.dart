import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:settings/model/map_destination_model.dart';

class MapDestinationSelectionDialog extends StatefulWidget {
  final List<MapDestinationModel> availableMaps;
  final MapDestinationDestination selection;

  const MapDestinationSelectionDialog(
      {required this.availableMaps, required this.selection, super.key});

  @override
  State<StatefulWidget> createState() => MapDestinationSelectionDialogState();
}

class MapDestinationSelectionDialogState
    extends State<MapDestinationSelectionDialog> {
  late MapDestinationDestination mapDestination;

  @override
  void initState() {
    mapDestination = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(tr('settings.app.navigation_map.title')),
        children: widget.availableMaps
                .map<Widget>(
                  (map) => RadioListTile<MapDestinationDestination>(
                    value: map.destination,
                    groupValue: mapDestination,
                    onChanged: (_) {
                      setState(() {
                        mapDestination = map.destination;
                      });
                      Navigator.of(context).pop(map.destination);
                    },
                    title: Text(map.label),
                  ),
                )
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
  }
}
