import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings/version/ui/version_item.dart';
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
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.github),
            title: const Text("Github"),
            subtitle: const Text("@tankste")),
      ]),
      _buildCard(context, "Kontakt", [
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
      _buildCard(context, "Rechtliches", [
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
      _buildCard(context, "About", [
        // ListTile(
        //     onTap: () {
        //       _openUrl("https://status.tankste.app/");
        //     },
        //     minLeadingWidth: 8,
        //     leading: const Icon(Icons.traffic),
        //     title: const Text("Status")),
        const VersionItem()
      ]),
      Padding(
          padding: EdgeInsets.only(top: 16),
          child: Center(
              child: Text(TimeOfDay.now().hour >= 19 // Show a beer after 20:00 :p
                  ? "Made with \u{2665} and \u{1F37A} in \u{1F1E9}\u{1F1EA}."
                  : "Made with \u{2665} and \u{2615} in \u{1F1E9}\u{1F1EA}.")))
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
