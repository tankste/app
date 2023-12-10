import 'package:core/cubit/base_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/custom_switch_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class FeatureSettingsPage extends StatelessWidget {
  const FeatureSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Experimentelle Funktionen"),
        ),
        body: SafeArea(child: _buildBody(context)));
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: Text("Aktuell sind keine neuen Funktionen verfügbar."));
  }
}
