import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OpenTimeStateSelectionDialog extends StatefulWidget {
  final String selection;

  const OpenTimeStateSelectionDialog({required this.selection, super.key});

  @override
  State<StatefulWidget> createState() => OpenTimeStateSelectionDialogState();
}

class OpenTimeStateSelectionDialogState
    extends State<OpenTimeStateSelectionDialog> {
  late String openTimeState;

  @override
  void initState() {
    openTimeState = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text(tr('report.open_times.title')), children: [
      RadioListTile<String>(
          value: "true",
          groupValue: openTimeState,
          onChanged: (_) {
            setState(() {
              openTimeState = "true";
            });
            Navigator.of(context).pop("true");
          },
          title: Text(tr('report.open_times.open'))),
      RadioListTile<String>(
        value: "false",
        groupValue: openTimeState,
        onChanged: (_) {
          setState(() {
            openTimeState = "false";
          });
          Navigator.of(context).pop("false");
        },
        title: Text(tr('report.open_times.closed')),
      ),
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
