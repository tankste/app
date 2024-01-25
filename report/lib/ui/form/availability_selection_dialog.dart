import 'package:flutter/material.dart';

class AvailabilitySelectionDialog extends StatefulWidget {
  final String selection;

  const AvailabilitySelectionDialog(
      {required this.selection, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => AvailabilitySelectionDialogState();
}

class AvailabilitySelectionDialogState extends State<AvailabilitySelectionDialog> {
  late String availability;

  @override
  void initState() {
    availability = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: const Text("Verfügbarkeit"), children: [
      RadioListTile<String>(
        value: "available",
        groupValue: availability,
        onChanged: (_) {
          setState(() {
            availability = "Verfügbar";
          });
          Navigator.of(context).pop("Verfügbar");
        },
        title: const Text("Verfügbar"),
      ),
      RadioListTile<String>(
        value: "temporary_closed",
        groupValue: availability,
        onChanged: (_) {
          setState(() {
            availability = "temporary_closed";
          });
          Navigator.of(context).pop("temporary_closed");
        },
        title: const Text("Temporär geschlossen"),
      ),
      RadioListTile<String>(
        value: "permanent_closed",
        groupValue: availability,
        onChanged: (_) {
          setState(() {
            availability = "permanent_closed";
          });
          Navigator.of(context).pop("permanent_closed");
        },
        title: const Text("Dauerhaft geschlossen"),
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
