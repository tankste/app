import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_ui/ui/become/become_membership_page.dart';
import 'package:sponsor_ui/ui/item/cubit/membership_map_item_cubit.dart';
import 'package:sponsor_ui/ui/item/cubit/membership_map_item_state.dart';

class MembershipMapItem extends StatelessWidget {
  const MembershipMapItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MembershipMapItemCubit(),
        child: BlocConsumer<MembershipMapItemCubit, MembershipMapItemState>(
            listener: (context, state) {},
            builder: (context, state) {
              return SizedBox(
                  width: 64, child: Card(child: _buildContent(context, state)));
            }));
  }

  Widget _buildContent(BuildContext context, MembershipMapItemState state) {
    if (state is LoadingMembershipMapItemState) {
      return Padding(
          padding: EdgeInsets.all(16),
          child:
              AspectRatio(aspectRatio: 1, child: CircularProgressIndicator()));
    } else if (state is ErrorMembershipMapItemState) {
      return _buildInactiveMemberContent(context);
    } else if (state is InfoMembershipMapItemState) {
      if (state.isMember) {
        return _buildActiveMemberContent(context);
      } else {
        return _buildInactiveMemberContent(context);
      }
    }

    return Container();
  }

  Widget _buildInactiveMemberContent(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BecomeMembershipPage()));
        },
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.favorite_border,
              color: Theme.of(context).primaryColor,
            )));
  }

  Widget _buildActiveMemberContent(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Container()));
        },
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
            )));
  }
}
