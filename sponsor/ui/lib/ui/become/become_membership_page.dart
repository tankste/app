import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_ui/ui/become/cubit/become_membership_cubit.dart';
import 'package:sponsor_ui/ui/become/cubit/become_membership_state.dart';
import 'package:url_launcher/url_launcher.dart';

class BecomeMembershipPage extends StatelessWidget {
  const BecomeMembershipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
        ),
        body: BlocProvider(
            create: (context) => BecomeMembershipCubit(),
            child: BlocConsumer<BecomeMembershipCubit, BecomeMembershipState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return SafeArea(child: _buildBody(context, state));
                })));
  }

  Widget _buildBody(BuildContext context, BecomeMembershipState state) {
    return SingleChildScrollView(
        child: Center(
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
                    Text(tr('sponsor.become.title'),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 1),
                              _buildPoint(context, tr('sponsor.points.1')),
                              _buildPoint(context, tr('sponsor.points.2')),
                              _buildPoint(context, tr('sponsor.points.3')),
                              _buildPoint(context, tr('sponsor.points.4')),
                              _buildPoint(context, tr('sponsor.points.5')),
                              _buildPoint(context, tr('sponsor.points.6')),
                            ])),
                    SizedBox(height: 16),
                    state is ProductsBecomeMembershipState
                        ? Row(
                            children: [
                              Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        context
                                            .read<BecomeMembershipCubit>()
                                            .onBuyYearSubscriptionClicked();
                                      },
                                      child: Text(state.yearPrice)))
                            ],
                          )
                        : Container(),
                    state is ProductsBecomeMembershipState
                        ? Row(
                            children: [
                              Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        context
                                            .read<BecomeMembershipCubit>()
                                            .onBuyMonthSubscriptionClicked();
                                      },
                                      child: Text(state.monthPrice)))
                            ],
                          )
                        : Container(),
                    ..._buildProviderItems(state),
                    state is ErrorBecomeMembershipState
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Text(tr('sponsor.error'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)))
                        : Container(),
                    state is BoughtBecomeMembershipState
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Text(tr('sponsor.bought'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)))
                        : Container(),
                    state is LoadingBecomeMembershipState?
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: CircularProgressIndicator())
                        : Container(),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          spacing: 32,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                                flex: 1,
                                child: TextButton(
                                    onPressed: () {
                                      _openUrl(
                                          "https://tankste.app/datenschutz");
                                    },
                                    child: Text(
                                        tr('settings.legal.privacy.title')))),
                            Flexible(
                                flex: 1,
                                child: TextButton(
                                    onPressed: () {
                                      _openUrl(
                                          "https://tankste.app/nutzungsbedingungen/");
                                    },
                                    child: Text(
                                        tr('settings.legal.terms.title')))),
                          ],
                        )),
                    SizedBox(height: 8),
                    state is! ProvidersBecomeMembershipState
                        ? Text(tr('sponsor.note'),
                            style: Theme.of(context).textTheme.bodySmall)
                        : Container()
                  ],
                ))));
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

  List<Widget> _buildProviderItems(BecomeMembershipState state) {
    if (state is ProvidersBecomeMembershipState) {
      return state.providers
          .map((provider) => Row(
                children: [
                  Expanded(
                      child: FilledButton(
                          onPressed: () {
                            _openUrl(provider.url.toString());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 6,
                            children: [
                              Image.asset(
                                "assets/images/logos/${provider.logoName}.png",
                                package: "sponsor_ui",
                                height: 18,
                              ),
                              Text(provider.label)
                            ],
                          )))
                ],
              ))
          .toList(growable: false);
    }

    return [];
  }

  void _openUrl(String url) async {
    Uri uri = Uri.tryParse(url)!;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      //TODO: handle this case
//        throw 'Could not launch $url';
    }
  }
}
