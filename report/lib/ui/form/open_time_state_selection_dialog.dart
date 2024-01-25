import 'package:flutter/material.dart';

class OpenTimeStateSelectionDialog extends StatefulWidget {
  final String selection;

  const OpenTimeStateSelectionDialog(
      {required this.selection, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OpenTimeStateSelectionDialogState();
}

class OpenTimeStateSelectionDialogState extends State<OpenTimeStateSelectionDialog> {
  late String openTimeState;

  @override
  void initState() {
    openTimeState = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: const Text("Aktuell geöffnet?"), children: [
      RadioListTile<String>(
        value: "true",
        groupValue: openTimeState,
        onChanged: (_) {
          setState(() {
            openTimeState = "true";
          });
          Navigator.of(context).pop("true");
        },
        title: const Text("Geöffnet"),
      ),
      RadioListTile<String>(
        value: "false",
        groupValue: openTimeState,
        onChanged: (_) {
          setState(() {
            openTimeState = "false";
          });
          Navigator.of(context).pop("false");
        },
        title: const Text("Geschlossen"),
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
