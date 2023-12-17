import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:settings/ui/developer/cubit/developer_card_cubit.dart';
import 'package:settings/ui/developer/cubit/developer_card_state.dart';
import 'package:settings/ui/feature/feature_settings_page.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/custom_switch_list_tile.dart';

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DeveloperCardCubit(),
        child: BlocConsumer<DeveloperCardCubit, DeveloperCardState>(
            listener: (context, state) {
              if (state
                  is SuccessRestLocationPermissionEnabledDeveloperCardState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Standortberechtigung zurückgesetzt"),
                ));
              } else if (state
                  is ErrorRestLocationPermissionEnabledDeveloperCardState) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Es ist ein Fehler aufgetreten!"),
                ));
              }
            },
            builder: (context, state) => _buildBody(context, state)));
  }

  Widget _buildBody(BuildContext context, DeveloperCardState state) {
    if (state is LoadingDeveloperCardState) {
      return Container();
    } else if (state is DisabledDeveloperCardState) {
      return Container();
    } else if (state is EnabledDeveloperCardState) {
      return SettingsCard(title: "Entwickler", items: [
        CustomSwitchListTile(
          value: true,
          onChanged: (value) {
            context.read<DeveloperCardCubit>().onDeveloperModeChanged(value);
          },
          minLeadingWidth: 8,
          secondary: const Icon(Icons.code),
          title: const Text("Entwicklermodus"),
          subtitle: const Text("Deaktiviere den Entwicklermodus"),
        ),
        ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FeatureSettingsPage()));
          },
          minLeadingWidth: 8,
          leading: const Icon(FontAwesomeIcons.wandMagicSparkles),
          title: const Text("Experimentelle Funktionen"),
          subtitle: const Text("Aktiviere experimentelle Funktionen"),
        ),
        ListTile(
          onTap: () {
            context.read<DeveloperCardCubit>().onResetLocationClicked();
          },
          minLeadingWidth: 8,
          leading: const Icon(Icons.location_disabled),
          title: const Text("Standortberechtigung zurücksetzen"),
          subtitle: const Text("Löschen des Caches zur Standortberechtigung"),
        ),
      ]);
    } else if (state is ErrorDeveloperCardState) {
      return Container();
    }

    return Container();
  }
}
