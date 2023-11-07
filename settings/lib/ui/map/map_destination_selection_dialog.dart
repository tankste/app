import 'package:flutter/material.dart';
import 'package:settings/model/map_destination_model.dart';

class MapDestinationSelectionDialog extends StatefulWidget {
  final List<MapDestinationModel> availableMaps;
  final MapDestinationDestination selection;

  const MapDestinationSelectionDialog(
      {required this.availableMaps, required this.selection, Key? key})
      : super(key: key);

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
        title: const Text("Navigations App"),
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
                        child: const Text('Abbrechen'))
                  ],
                ),
              )
            ]);
  }
}
