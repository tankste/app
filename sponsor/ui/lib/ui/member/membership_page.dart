import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_ui/ui/member/cubit/membership_cubit.dart';
import 'package:sponsor_ui/ui/member/cubit/membership_state.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: BlocProvider(
            create: (context) => MembershipCubit(),
            child: BlocConsumer<MembershipCubit, MembershipState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return SafeArea(child: _buildBody(context, state));
                })));
  }

  Widget _buildBody(BuildContext context, MembershipState state) {
    return SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                    size: 160,
                  ),
                  SizedBox(height: 16),
                  Text(tr('sponsor.membership.title'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 32),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tr('sponsor.teaser'),
                                style: Theme.of(context).textTheme.titleMedium),
                            SizedBox(height: 1),
                            _buildPoint(context, tr('sponsor.points.1')),
                            _buildPoint(context, tr('sponsor.points.2')),
                            _buildPoint(context, tr('sponsor.points.3')),
                            _buildPoint(context, tr('sponsor.points.4')),
                            _buildPoint(context, tr('sponsor.points.5')),
                            _buildPoint(context, tr('sponsor.points.6')),
                          ])),
                  SizedBox(height: 32),
                  state is InfoMembershipState
                      ? InkWell(
                          onTap: () {
                            context
                                .read<MembershipCubit>()
                                .onSymbolOptionChanged(!state.showSymbol);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Switch(
                                    value: state.showSymbol,
                                    onChanged: (enabled) {
                                      context
                                          .read<MembershipCubit>()
                                          .onSymbolOptionChanged(enabled);
                                    }),
                                Text(tr('sponsor.symbol_option'))
                              ]))
                      : Container()
                ])));
  }

  Widget _buildPoint(BuildContext context, String text) {
    return Row(spacing: 6, children: [
      Text("✓",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      Expanded(
          child: Text(text, style: Theme.of(context).textTheme.titleMedium))
    ]);
  }
}
