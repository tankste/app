import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/ui/custom_switch_list_tile.dart';
import 'package:settings/ui/feature/cubit/feature_settings_cubit.dart';
import 'package:settings/ui/feature/cubit/feature_settings_state.dart';

class FeatureSettingsPage extends StatelessWidget {
  const FeatureSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FeatureSettingsCubit(),
        child: BlocConsumer<FeatureSettingsCubit, FeatureSettingsState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text(tr('settings.developer.feature_flags.title')),
                  ),
                  body: SafeArea(child: _buildBody(context, state)));
            }));
  }

  Widget _buildBody(BuildContext context, FeatureSettingsState state) {
    if (state is LoadingFeatureSettingsState) {
      return const Center(child: CircularProgressIndicator());
    } else if(state is FeaturesFeatureSettingsState) {
      return ListView.builder(
          itemCount: state.availableFeatures.length,
          itemBuilder: (context, index) {
            Feature feature = state.availableFeatures[index];
            return CustomSwitchListTile(
              value: state.enabledFeatures.contains(feature),
              onChanged: (value) {
                context
                    .read<FeatureSettingsCubit>()
                    .onFeatureEnableChanged(feature, value);
              },
              minLeadingWidth: 8,
              // secondary: const Icon(Icons.gps_off),
              title: Text(feature.name),
            );
          });
    }

    return Container();
  }
}
