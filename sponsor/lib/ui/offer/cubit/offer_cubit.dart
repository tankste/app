import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/repository/product_repository.dart';
import 'package:sponsor/repository/sponsorship_repository.dart';
import 'package:sponsor/ui/offer/cubit/offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  final ProductRepository _productRepository =
      SponsorModuleFactory.createProductRepository();

  final SponsorshipRepository _sponsorshipRepository =
      SponsorModuleFactory.createSponsorshipRepository();

  OfferCubit() : super(LoadingOfferState()) {
    _fetchItems();
  }

  void _fetchItems() {
    emit(LoadingOfferState());

    CombineLatestStream.combine4(
        _sponsorshipRepository.get(),
        _productRepository.get('app.tankste.sponsor.sub.yearly.12'),
        _productRepository.get('app.tankste.sponsor.sub.monthly.2'),
        _productRepository.get('app.tankste.sponsor.product.10'),
        (sponsorshipResult, yearlySubscriptionProductResult,
            monthlySubscriptionProductResult, onceTenProductResult) {
      return sponsorshipResult.when((sponsorship) {
        return yearlySubscriptionProductResult.when(
            (yearlySubscriptionProduct) {
          return monthlySubscriptionProductResult.when(
              (monthlySubscriptionProduct) {
            return onceTenProductResult.when((onceTenProduct) {
              List<OfferItem> items = [];
              if (sponsorship.activeSubscriptionId == null) {
                items.add(OfferItem(
                    id: yearlySubscriptionProduct.id,
                    labelPrice: yearlySubscriptionProduct.priceLabel,
                    labelType: "/ Jährlich",
                    hint:
                        "Unterstütze tankste! mit einer jährlichen Zahlung von ${yearlySubscriptionProduct.priceLabel}."));

                items.add(OfferItem(
                    id: monthlySubscriptionProduct.id,
                    labelPrice: monthlySubscriptionProduct.priceLabel,
                    labelType: "/ Monatlich",
                    hint:
                        "Unterstütze tankste! mit einer monatlichen Zahlung von ${monthlySubscriptionProduct.priceLabel}."));
              }

              items.add(OfferItem(
                  id: onceTenProduct.id,
                  labelPrice: onceTenProduct.priceLabel,
                  labelType: "/ Einmalig",
                  hint:
                      "Unterstütze tankste! mit einer einmaligen Zahlung von ${onceTenProduct.priceLabel}."));

              return OffersOfferState(
                  title: sponsorship.activeSubscriptionId != null
                      ? "Zusätzliche Optionen"
                      : "Optionen",
                  isSponsorshipInfoVisible: sponsorship.value > 0,
                  sponsoredValue: "${sponsorship.value.round()} €",
                  activeSubscription: sponsorship.activeSubscriptionId != null
                      ? [
                          yearlySubscriptionProduct,
                          monthlySubscriptionProduct,
                          onceTenProduct
                        ]
                          .firstWhereOrNull((element) =>
                              element.id == sponsorship.activeSubscriptionId)
                          ?.title
                      : null,
                  items: items);
            }, (error) => ErrorOfferState(errorDetails: error.toString()));
          }, (error) => ErrorOfferState(errorDetails: error.toString()));
        }, (error) => ErrorOfferState(errorDetails: error.toString()));
      }, (error) => ErrorOfferState(errorDetails: error.toString()));
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }

  void onSponsorItemClicked(String itemId) {
    _productRepository.purchase(itemId).listen((result) {
      if (isClosed) {
        return;
      }

      if (result.isError()) {
        emit(ErrorPurchaseLoadingOfferState(
            errorDetails: result.tryGetError()?.toString()));
        _fetchItems();
      }

      OfferState state = this.state;
      if (state is OffersOfferState) {
        emit(PurchasedOffersOfferState(
            title: state.title,
            items: state.items,
            sponsoredValue: state.sponsoredValue,
            activeSubscription: state.activeSubscription,
            isSponsorshipInfoVisible: state.isSponsorshipInfoVisible));
      }
    });
  }

  void onRetryClicked() {
    _fetchItems();
  }
}
