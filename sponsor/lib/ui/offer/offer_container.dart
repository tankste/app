import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sponsor/ui/offer/cubit/offer_cubit.dart';
import 'package:sponsor/ui/offer/cubit/offer_state.dart';

class OfferContainer extends StatelessWidget {
  const OfferContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OfferCubit(),
        child: BlocConsumer<OfferCubit, OfferState>(listener: (context, state) {
          if (state is ErrorPurchaseLoadingOfferState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(tr('generic.error.short')),
            ));
          } else if (state is PurchasedOffersOfferState) {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    content: Lottie.asset(
                      'assets/lottie/thank_you.json',
                      package: 'sponsor',
                      repeat: false,
                      onLoaded: (composition) async {
                        await Future.delayed(
                            composition.duration + const Duration(seconds: 2));
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  );
                });
          }
        }, builder: (context, state) {
          return SafeArea(child: _buildBody(context, state));
        }));
  }

  Widget _buildBody(BuildContext context, OfferState state) {
    if (state is LoadingOfferState) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator()));
    } else if (state is ErrorOfferState) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Text(tr('generic.error.title'),
                style: Theme.of(context).textTheme.headlineSmall),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tr('generic.error.long'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                    onPressed: () {
                      context.read<OfferCubit>().onRetryClicked();
                    },
                    child: Text(tr('generic.retry.long')))),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(tr('generic.error.details.title')),
                          content: Text(state.errorDetails.toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text(tr('generic.ok')),
                            )
                          ],
                        );
                      });
                },
                child: Text(tr('generic.error.details.show'))),
          ]));
    } else if (state is OffersOfferState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        state.isSponsorshipInfoVisible
            ? Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr('sponsor.overview.info.sponsorship.title'),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleLarge),
                      Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                              tr('sponsor.overview.info.sponsorship.description'),
                              style: const TextStyle(fontSize: 16))),
                      state.activeSubscription != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                  tr('sponsor.overview.info.sponsorship.active_subscription',
                                      args: [state.activeSubscription!]),
                                  style: const TextStyle(fontSize: 16)))
                          : Container(),
                      Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                              tr('sponsor.overview.info.sponsorship.comment_hint'),
                              style: const TextStyle(fontSize: 16))),
                    ]))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Text(tr('sponsor.overview.info.new.title'),
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: Text(tr('sponsor.overview.info.new.description'),
                        style: const TextStyle(fontSize: 16)),
                  ),
                  //TODO: add more information link
                ],
              ),
        state.items.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Text(state.title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge),
              )
            : Container(),
        ...state.items.map((item) => Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<OfferCubit>().onSponsorItemClicked(item.id);
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.labelPrice,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white)),
                        Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(item.labelType,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.white)))
                      ]),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(item.hint,
                        style: Theme.of(context).textTheme.bodySmall)),
              ],
            ))),
        state.items.isNotEmpty && Platform.isIOS
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: TextButton(
                        onPressed: () {
                          context.read<OfferCubit>().onRestoreClicked();
                        },
                        child: Text(tr('sponsor.overview.restore')))))
            : Container(),
        //TODO: add later more options to sponsor
        // Center(
        //     child: Padding(
        //         padding: EdgeInsets.only(left: 8, right: 8),
        //         child: TextButton(
        //             onPressed: () {},
        //             child: Text("Weitere Möglichkeiten anzeigen")))),
      ]);
    } else {
      return Container();
    }
  }
}
