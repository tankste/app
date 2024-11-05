import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AvailabilitySelectionDialog extends StatefulWidget {
  final String selection;

  const AvailabilitySelectionDialog(
      {required this.selection, super.key});

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
    return SimpleDialog(title: Text(tr('report.availability.title')), children: [
      RadioListTile<String>(
        value: "available",
        groupValue: availability,
        onChanged: (_) {
          setState(() {
            availability = 'available';
          });
          Navigator.of(context).pop('available');
        },
        title: Text(tr('report.availability.available')),
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
        title: Text(tr('report.availability.temporarily_closed')),
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
        title: Text(tr('report.availability.permanently_closed')),
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
