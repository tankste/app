import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/theme/cubit/theme_item_cubit.dart';
import 'package:settings/ui/theme/cubit/theme_item_state.dart';
import 'package:settings/ui/theme/theme_selection_dialog.dart';

class ThemeItem extends StatelessWidget {
  const ThemeItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ThemeItemCubit(),
        child: BlocConsumer<ThemeItemCubit, ThemeItemState>(
            listener: (context, state) {},
            builder: (context, state) {
              return ListTile(
                  onTap: () {
                    _showSelectionDialog(
                        context, state.designValue ?? ThemeMode.system);
                  },
                  minLeadingWidth: 10,
                  leading: const Icon(Icons.brightness_4),
                  title: Text(tr('settings.app.design.title')),
                  subtitle: Text(state.designLabel ?? ""));
            }));
  }

  void _showSelectionDialog(BuildContext context, ThemeMode theme) {
    showDialog(
        context: context,
        builder: (context) {
          return ThemeSelectionDialog(selection: theme);
        }).then((theme) {
      if (theme != null) {
        context.read<ThemeItemCubit>().onThemeChanged(theme);
      }
    });
  }
}
