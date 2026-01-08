import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings/ui/currency/currency_item.dart';
import 'package:settings/ui/developer/developer_card.dart';
import 'package:settings/ui/map/map_provider_item.dart';
import 'package:settings/ui/navigation/map_destination_item.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/support/support_card.dart';
import 'package:settings/ui/theme/theme_item.dart';
import 'package:settings/ui/version/version_item.dart';
import 'package:sponsor_ui/ui/setting/sponsor_setting_item.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = _buildItems(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(tr('settings.title')),
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
      SettingsCard(title: tr('settings.app.title'), items: [
        ThemeItem(),
        MapProviderItem(),
        MapDestinationItem(),
        CurrencyItem()
      ]),
      SettingsCard(title: tr('settings.open_source.title'), items: [
        SponsorSettingItem(),
        ListTile(
          onTap: () {
            _openUrl(
                "https://github.com/tankste/app/tree/main/app/assets/translations");
          },
          minLeadingWidth: 8,
          leading: const Icon(Icons.translate),
          title: Text(tr('settings.open_source.translation.title')),
          subtitle: Text(tr('settings.open_source.translation.description')),
        ),
        ListTile(
            onTap: () {
              _openUrl("https://github.com/tankste/app");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.github),
            title: Text(tr('settings.open_source.source_code.title')),
            subtitle: Text(tr('settings.open_source.source_code.description'))),
      ]),
      SettingsCard(title: tr('settings.contact.title'), items: [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.public),
            title: Text(tr('settings.contact.website.title')),
            subtitle: Text(tr('settings.contact.website.description'))),
        ListTile(
            onTap: () {
              _openUrl("mailto:hey@tankste.app");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.mail),
            title: Text(tr('settings.contact.email.title')),
            subtitle: Text(tr('settings.contact.email.description'))),
        ListTile(
            onTap: () {
              _openUrl("https://www.instagram.com/tankste.app");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.instagram),
            title: Text(tr('settings.contact.instagram.title')),
            subtitle: Text(tr('settings.contact.instagram.description'))),
        ListTile(
            onTap: () {
              _openUrl("https://twitter.com/tankste_app");
            },
            minLeadingWidth: 8,
            leading: const Icon(FontAwesomeIcons.twitter),
            title: Text(tr('settings.contact.twitter.title')),
            subtitle: Text(tr('settings.contact.twitter.description')))
      ]),
      SettingsCard(title: tr('settings.legal.title'), items: [
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/datenquellen");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.source),
            title: Text(tr('settings.legal.data_source.title'))),
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/nutzungsbedingungen");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.account_balance),
            title: Text(tr('settings.legal.terms.title'))),
        ListTile(
            onTap: () {
              _openUrl("https://tankste.app/datenschutz");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.local_police),
            title: Text(tr('settings.legal.privacy.title')))
      ]),
      const DeveloperCard(),
      const SupportCard(),
      SettingsCard(title: tr('settings.about.title'), items: [
        ListTile(
            onTap: () {
              _openUrl("https://status.tankste.app/");
            },
            minLeadingWidth: 8,
            leading: const Icon(Icons.traffic),
            title: Text(tr('settings.about.status.title'))),
        const VersionItem()
      ]),
      Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
              child: Text(tr('settings.footer.note', args: [
            "\u{2665}",
            TimeOfDay.now().hour >= 19 ? "\u{1F37A}" : "\u{2615}",
            "\u{1F1E9}\u{1F1EA}"
          ])))),
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
