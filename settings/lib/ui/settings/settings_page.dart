import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings/ui/developer/developer_card.dart';
import 'package:settings/ui/map/map_destination_item.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/theme/theme_item.dart';
import 'package:settings/ui/version/version_item.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = _buildItems(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Einstellungen"),
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
        )));
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      const SettingsCard(
          title: "App", items: [ThemeItem(), MapDestinationItem()]),
      SettingsCard(title: "Unterstütze uns", items: [
        ListTile(
            onTap: () {
              _openUrl("https://github.com/tankste");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.github),
            title: const Text("Github"),
            subtitle: const Text("@tankste")),
      ]),
      SettingsCard(title: "Kontakt", items: [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.public),
            title: const Text("Webseite"),
            subtitle: const Text("tankste.app")),
        ListTile(
            onTap: () {
              _openUrl("mailto:hey@tankste.app");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.mail),
            title: const Text("E-Mail"),
            subtitle: const Text("hey@tankste.app")),
        ListTile(
            onTap: () {
              _openUrl("https://www.instagram.com/tankste.app");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.instagram),
            title: const Text("Instagram"),
            subtitle: const Text("@tankste.app")),
        ListTile(
            onTap: () {
              _openUrl("https://twitter.com/tankste_app");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.twitter),
            title: const Text("Twitter"),
            subtitle: const Text("@tankste_app"))
      ]),
      SettingsCard(title: "Rechtliches", items: [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/nutzungsbedingungen");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.account_balance),
            title: const Text("Nutzungsbedingungen")),
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/datenschutz");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.local_police),
            title: const Text("Datenschutzbestimmungen"))
      ]),
      const DeveloperCard(),
      const SettingsCard(title: "Über", items: [
        // ListTile(
        //     onTap: () {
        //       _openUrl("https://status.tankste.app/");
        //     },
        //     minLeadingWidth: 8,
        //     leading: const Icon(Icons.traffic),
        //     title: const Text("Status")),
        VersionItem()
      ]),
      Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
              child: Text(TimeOfDay.now().hour >=
                      19 // Show a beer after 20:00 :p
                  ? "Made with \u{2665} and \u{1F37A} in \u{1F1E9}\u{1F1EA}."
                  : "Made with \u{2665} and \u{2615} in \u{1F1E9}\u{1F1EA}.")))
    ];
  }

  void _openUrl(String url) async {
    Uri uri = Uri.tryParse(url)!;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      //TODO: handle this case
//        throw 'Could not launch $url';
    }
  }
}
