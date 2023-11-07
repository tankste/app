import 'package:flutter/material.dart';
import 'package:settings/model/developer_settings_model.dart';

class MapProviderSelectionDialog extends StatefulWidget {
  final DeveloperSettingsMapProvider selection;

  const MapProviderSelectionDialog(
      {required this.selection, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MapProviderSelectionDialogState();
}

class MapProviderSelectionDialogState extends State<MapProviderSelectionDialog> {
  late DeveloperSettingsMapProvider mapProvider;

  @override
  void initState() {
    mapProvider = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: const Text("Kartenanbieter"), children: [
      RadioListTile<DeveloperSettingsMapProvider>(
        value: DeveloperSettingsMapProvider.system,
        groupValue: mapProvider,
        onChanged: (_) {
          setState(() {
            mapProvider = DeveloperSettingsMapProvider.system;
          });
          Navigator.of(context).pop(DeveloperSettingsMapProvider.system);
        },
        title: const Text("Systemstandard"),
      ),
      RadioListTile<DeveloperSettingsMapProvider>(
        value: DeveloperSettingsMapProvider.google,
        groupValue: mapProvider,
        onChanged: (_) {
          setState(() {
            mapProvider = DeveloperSettingsMapProvider.google;
          });
          Navigator.of(context).pop(DeveloperSettingsMapProvider.google);
        },
        title: const Text("Google Maps"),
      ),
      RadioListTile<DeveloperSettingsMapProvider>(
        value: DeveloperSettingsMapProvider.openStreet,
        groupValue: mapProvider,
        onChanged: (_) {
          setState(() {
            mapProvider = DeveloperSettingsMapProvider.openStreet;
          });
          Navigator.of(context).pop(DeveloperSettingsMapProvider.openStreet);
        },
        title: const Text("Open Street Map"),
      ),
      RadioListTile<DeveloperSettingsMapProvider>(
        value: DeveloperSettingsMapProvider.apple,
        groupValue: mapProvider,
        onChanged: (_) {
          setState(() {
            mapProvider = DeveloperSettingsMapProvider.apple;
          });
          Navigator.of(context).pop(DeveloperSettingsMapProvider.apple);
        },
        title: const Text("Apple Maps"),
      ),
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
