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
            listener: (context, state) {},
            builder: (context, state) {
              if (state.isVisible != true) {
                return Container();
              }

              return SettingsCard(title: "Entwickler", items: [
                CustomSwitchListTile(
                  value: state.isVisible == true,
                  onChanged: (value) {
                    context
                        .read<DeveloperCardCubit>()
                        .onDeveloperModeChanged(value);
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
              ]);
            }));
  }
}
