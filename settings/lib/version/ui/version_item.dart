import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/version/ui/cubit/version_item_cubit.dart';
import 'package:settings/version/ui/cubit/version_item_state.dart';
import 'package:settings/version/ui/cubit/version_item_state.dart';

class VersionItem extends StatelessWidget {
  const VersionItem({Key? key}) : super(key: key);

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
              title: const Text("Version"),
              subtitle: Text(state.version ?? "..."));
        }));
  }
}
