import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/version/cubit/version_item_cubit.dart';
import 'package:settings/ui/version/cubit/version_item_state.dart';

class VersionItem extends StatelessWidget {
  const VersionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => VersionItemCubit(),
        child: BlocConsumer<VersionItemCubit, VersionItemState>(
            listener: (context, state) {
          if (state.isDeveloperModeEnabledInfoVisible == true) {
            const snackBar = SnackBar(
              content: Text('Entwickler Modus aktiviert!'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }, builder: (context, state) {
          return ListTile(
              minLeadingWidth: 10,
              leading: const Icon(Icons.info),
              onTap: () {
                context.read<VersionItemCubit>().onClicked();
              },
              title: Text(tr('settings.about.version.title')),
              subtitle: Text(state.version ?? "..."));
        }));
  }
}
