import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const SettingsCard({required this.title, required this.items, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(context).textTheme.headline6)),
        ...items
      ],
    ));
  }
}
