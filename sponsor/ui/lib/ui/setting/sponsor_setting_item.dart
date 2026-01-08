import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_ui/ui/become/become_membership_page.dart';
import 'package:sponsor_ui/ui/member/membership_page.dart';
import 'package:sponsor_ui/ui/setting/cubit/sponsor_setting_item_cubit.dart';
import 'package:sponsor_ui/ui/setting/cubit/sponsor_setting_item_state.dart';

class SponsorSettingItem extends StatelessWidget {
  const SponsorSettingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SponsorSettingItemCubit(),
        child: BlocConsumer<SponsorSettingItemCubit, SponsorSettingItemState>(
            listener: (context, state) {},
            builder: (context, state) {
              return ListTile(
                onTap: () {
                  if (state is InfoSponsorSettingItemState && state.isMember) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MembershipPage()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BecomeMembershipPage()));
                  }
                },
                minLeadingWidth: 8,
                leading: const Icon(Icons.favorite),
                title: Text(tr('settings.open_source.sponsor.title')),
                subtitle: Text(tr('settings.open_source.sponsor.description')),
              );
            }));
  }
}
