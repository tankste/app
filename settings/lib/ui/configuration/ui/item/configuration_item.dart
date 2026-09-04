import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/configuration/ui/form/configuration_form_page.dart';
import 'package:settings/ui/configuration/ui/item/configuration_item_cubit.dart';
import 'package:settings/ui/configuration/ui/item/configuration_item_state.dart';

class ConfigurationItem extends StatelessWidget {
  const ConfigurationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfigurationItemCubit(),
      child: BlocConsumer<ConfigurationItemCubit, ConfigurationItemState>(
        listener: (context, state) {},
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ConfigurationItemState state) {
    if (state is AvailableConfigurationItemState) {
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

    return Container();
  }
}
