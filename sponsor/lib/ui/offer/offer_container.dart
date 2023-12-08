import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sponsor/ui/offer/cubit/offer_cubit.dart';
import 'package:sponsor/ui/offer/cubit/offer_state.dart';

class OfferContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => OfferCubit(),
        child: BlocConsumer<OfferCubit, OfferState>(listener: (context, state) {
          if (state is ErrorPurchaseLoadingOfferState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Something went wrong!"),
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
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(children: [
            Text("Fehler!", style: Theme.of(context).textTheme.headline5),
            Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "Es ist ein Fehler aufgetreten. Bitte prüfe deine Internetverbindung oder versuche es später erneut.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                    onPressed: () {
                      context.read<OfferCubit>().onRetryClicked();
                    },
                    child: const Text("Wiederholen"))),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Fehler Details'),
                          content: Text(state.errorDetails.toString()),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Ok')),
                          ],
                        );
                      });
                },
                child: const Text("Fehler anzeigen")),
          ]));
    } else if (state is OffersOfferState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        state.isSponsorshipInfoVisible
            ? Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Du unterstützt tankste!",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.titleLarge),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                              "Ein großes Dankeschön an dich, dass du mir hilft das Projekt tankste! am Leben zu halten! Du hast dem Projekt bereits mit ${state.sponsoredValue} ausgeholfen, und somit die Weiterentwicklung voran getrieben.",
                              style: TextStyle(fontSize: 16))),
                      state.activeSubscription != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                  "Zur Zeit hast du das Abonnement „${state.activeSubscription}“ aktiv.",
                                  style: TextStyle(fontSize: 16)))
                          : Container(),
                      Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                              "Du wirst weiter unten als Sponsor gelistet. Du kannst einen Namen angeben, und zusätzlich einen Kommentar hinterlassen. Diese Angbaen sind für alle Nutzer sichtbar.",
                              style: TextStyle(fontSize: 16))),
                    ]))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Text("tankste! braucht dich!",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 16, right: 16),
                    child: Text(
                        "Um die laufenden Kosten zu decken, bin ich auf eure finazielle Hilfe angewiesen.\nDu sparst mit tankste! regelmäßig Geld beim Tanken? Dann überlass dem Projekt doch einen kleinen Betrag davon.\nSo bleibt die App auch in Zukunft werbefrei!",
                        style: TextStyle(fontSize: 16)),
                  ),
                  //TODO: add more information link
                ],
              ),
        Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Text(state.title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ...state.items.map((item) => Padding(
            padding: EdgeInsets.only(top: 8, left: 16, right: 16),
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
                            padding: EdgeInsets.only(left: 4),
                            child: Text(item.labelType,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(color: Colors.white)))
                      ]),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(item.hint,
                        style: Theme.of(context).textTheme.bodySmall)),
              ],
            ))),
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
