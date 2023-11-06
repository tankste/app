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
    return SimpleDialog(title: const Text("Design"), children: [
      RadioListTile<ThemeMode>(
        value: ThemeMode.system,
        groupValue: theme,
        onChanged: (_) {
          setState(() {
            theme = ThemeMode.system;
          });
          Navigator.of(context).pop(ThemeMode.system);
        },
        title: const Text("Systemstandard"),
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
        title: const Text("Hell"),
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
        title: const Text("Dunkel"),
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
