import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ThemeSelectionDialog extends StatefulWidget {
  final ThemeMode selection;

  const ThemeSelectionDialog(
      {required this.selection, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ThemeSelectionDialogState();
}

class ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  late ThemeMode theme;

  @override
  void initState() {
    theme = widget.selection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: Text(tr('settings.app.design.title')), children: [
      RadioListTile<ThemeMode>(
        value: ThemeMode.system,
        groupValue: theme,
        onChanged: (_) {
          setState(() {
            theme = ThemeMode.system;
          });
          Navigator.of(context).pop(ThemeMode.system);
        },
        title: Text(tr('settings.app.design.system')),
      ),
      RadioListTile<ThemeMode>(
        value: ThemeMode.light,
        groupValue: theme,
        onChanged: (_) {
          setState(() {
            theme = ThemeMode.light;
          });
          Navigator.of(context).pop(ThemeMode.light);
        },
        title: Text(tr('settings.app.design.light')),
      ),
      RadioListTile<ThemeMode>(
        value: ThemeMode.dark,
        groupValue: theme,
        onChanged: (_) {
          setState(() {
            theme = ThemeMode.dark;
          });
          Navigator.of(context).pop(ThemeMode.dark);
        },
        title: Text(tr('settings.app.design.dark')),
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
