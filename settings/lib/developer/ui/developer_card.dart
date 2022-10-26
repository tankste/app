import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/developer/ui/cubit/developer_card_cubit.dart';
import 'package:settings/developer/ui/cubit/developer_card_state.dart';
import 'package:settings/settings/settings_card.dart';
import 'package:settings/widget/custom_switch_list_tile.dart';

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
              ]);
            }));
  }
}
