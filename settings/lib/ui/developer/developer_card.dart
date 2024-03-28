import 'package:easy_localization/easy_localization.dart';
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
              if (state is SuccessDeleteCacheEnabledDeveloperCardState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tr('settings.developer.clear_cache.success')),
                ));
              } else if (state is ErrorDeleteCacheEnabledDeveloperCardState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(tr('generic.error.short')),
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
      return SettingsCard(title: tr('settings.developer.title'), items: [
        CustomSwitchListTile(
          value: true,
          onChanged: (value) {
            context.read<DeveloperCardCubit>().onDeveloperModeChanged(value);
          },
          minLeadingWidth: 8,
          secondary: const Icon(Icons.code),
          title: Text(tr('settings.developer.developer_mode.title')),
          subtitle: Text(tr('settings.developer.developer_mode.description')),
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
          title: Text(tr('settings.developer.feature_flags.title')),
          subtitle: Text(tr('settings.developer.feature_flags.description')),
        ),
        ListTile(
          onTap: () {
            context.read<DeveloperCardCubit>().onResetCacheClicked();
          },
          minLeadingWidth: 8,
          leading: const Icon(Icons.cookie_outlined),
          title: Text(tr('settings.developer.clear_cache.title')),
          subtitle: Text(tr('settings.developer.clear_cache.description')),
        ),
      ]);
    } else if (state is ErrorDeveloperCardState) {
      return Container();
    }

    return Container();
  }
}
