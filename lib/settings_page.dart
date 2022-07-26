import 'package:tankste/version_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> items = _buildItems(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Einstellungen"),
        ),
        body: ListView.builder(
          itemCount: items.length,
          padding: const EdgeInsets.all(8),
          itemBuilder: (BuildContext context, int index) {
            return items[index];
          },
        ));
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      _buildCard(context, "Unterstütze uns", [
        ListTile(
            onTap: () {
              _openUrl("https://github.com/tankste");
            },
            minLeadingWidth: 10,
            leading: const Icon(FontAwesomeIcons.github),
            title: const Text("Github")),
        ListTile(
            onTap: () {
              _openUrl("https://buymeacoffee.com/tankste");
            },
            minLeadingWidth: 10,
            leading: const Icon(FontAwesomeIcons.mugSaucer),
            title: const Text("Buy me a coffee")),
      ]),
      _buildCard(context, "Kontakt", [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/");
            },
            minLeadingWidth: 10,
            leading: const Icon(Icons.public),
            title: const Text("Webseite")),
        ListTile(
            onTap: () {
              _openUrl("mailto:hello@tankste.app");
            },
            minLeadingWidth: 10,
            leading: const Icon(Icons.mail),
            title: const Text("E-Mail")),
        ListTile(
            onTap: () {
              _openUrl("https://www.instagram.com/tankste.app");
            },
            minLeadingWidth: 10,
            leading: const Icon(FontAwesomeIcons.instagram),
            title: const Text("Instagram")),
        ListTile(
            onTap: () {
              _openUrl("https://twitter.com/tankste_app");
            },
            minLeadingWidth: 10,
            leading: const Icon(FontAwesomeIcons.twitter),
            title: const Text("Twitter"))
      ]),
      _buildCard(context, "Rechtliches", [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/nutzungsbedingungen");
            },
            minLeadingWidth: 10,
            leading: const Icon(Icons.account_balance),
            title: const Text("Nutzungsbedingungen")),
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/datenschutz");
            },
            minLeadingWidth: 10,
            leading: const Icon(Icons.local_police),
            title: const Text("Datenschutzbestimmungen"))
      ]),
      _buildCard(context, "About", [
        // ListTile(
        //     onTap: () {
        //       _openUrl("https://status.tankste.app/");
        //     },
        //     minLeadingWidth: 10,
        //     leading: const Icon(Icons.traffic),
        //     title: const Text("Status")),
        const VersionItem()
      ]),
      const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
              child: Text(
                  "Made with \u{2665} and \u{2615} in \u{1F1E9}\u{1F1EA}.")))
    ];
  }

  Widget _buildCard(BuildContext context, String title, List<Widget> items) {
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

  void _openUrl(String url) async {
    Uri uri = Uri.tryParse(url)!;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Can not launch $url");
      //TODO: handle this case
//        throw 'Could not launch $url';
    }
  }
}
