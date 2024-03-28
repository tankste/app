import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/ui/log/log_page.dart';
import 'package:settings/ui/settings/settings_card.dart';
import 'package:settings/ui/support/cubit/support_card_cubit.dart';
import 'package:settings/ui/support/cubit/support_card_state.dart';

class SupportCard extends StatelessWidget {
  const SupportCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SupportCardCubit(),
        child: BlocConsumer<SupportCardCubit, SupportCardState>(
            listener: (context, state) {},
            builder: (context, state) => _buildBody(context, state)));
  }

  Widget _buildBody(BuildContext context, SupportCardState state) {
    if (state is LoadingSupportCardState) {
      return Container();
    } else if (state is DisabledSupportCardState) {
      return Container();
    } else if (state is EnabledSupportCardState) {
      return SettingsCard(title: tr('settings.support.title'), items: [
        ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LogPage()));
          },
          minLeadingWidth: 8,
          leading: const Icon(Icons.list_outlined),
          title: Text(tr('settings.support.logs.title')),
          subtitle: Text(tr('settings.support.logs.description')),
        ),
      ]);
    }

    return Container();
  }
}
