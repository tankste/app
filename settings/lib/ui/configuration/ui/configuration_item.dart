import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:settings/ui/configuration/ui/configuration_form_page.dart';

class ConfigurationItem extends StatelessWidget {
  const ConfigurationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minLeadingWidth: 10,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfigurationFormPage()),
        );
      },
      leading: const Icon(Icons.electrical_services),
      title: Text(tr('settings.app.configuration.title')),
    );
  }
}
