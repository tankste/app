import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
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

    CombineLatestStream.combine6(
        _sponsorshipRepository.get(),
        _productRepository.get('app.tankste.sponsor.sub.yearly.12'),
        _productRepository.get('app.tankste.sponsor.sub.monthly.2'),
        _productRepository.get('app.tankste.sponsor.product.10'),
        _productRepository.get('app.tankste.sponsor.product.2'),
        _productRepository.get('app.tankste.sponsor.product.1'),
        (sponsorshipResult,
            yearlySubscriptionProductResult,
            monthlySubscriptionProductResult,
            onceTenProductResult,
            onceTwoProductResult,
            onceOneProductResult) {
      return sponsorshipResult.when((sponsorship) {
        return yearlySubscriptionProductResult.when(
            (yearlySubscriptionProduct) {
          return monthlySubscriptionProductResult.when(
              (monthlySubscriptionProduct) {
            return onceTenProductResult.when((onceTenProduct) {
              return onceTwoProductResult.when((onceTwoProduct) {
                return onceOneProductResult.when((onceOneProduct) {
                  List<OfferItem> items = [];
                  if (sponsorship.activeSubscriptionId == null) {
                    items.add(OfferItem(
                        id: yearlySubscriptionProduct.id,
                        labelPrice: yearlySubscriptionProduct.priceLabel,
                        labelType: tr('sponsor.overview.options.year.by'),
                        hint: tr('sponsor.overview.options.year.hint', args: [yearlySubscriptionProduct.priceLabel])));

                    items.add(OfferItem(
                        id: monthlySubscriptionProduct.id,
                        labelPrice: monthlySubscriptionProduct.priceLabel,
                        labelType: tr('sponsor.overview.options.month.by'),
                        hint: tr('sponsor.overview.options.month.hint', args: [monthlySubscriptionProduct.priceLabel])));

                    items.add(OfferItem(
                        id: onceTenProduct.id,
                        labelPrice: onceTenProduct.priceLabel,
                        labelType: tr('sponsor.overview.options.single.by'),
                        hint: tr('sponsor.overview.options.single.hint', args: [onceTenProduct.priceLabel])));

                    items.add(OfferItem(
                        id: onceTwoProduct.id,
                        labelPrice: onceTwoProduct.priceLabel,
                        labelType: tr('sponsor.overview.options.single.by'),
                        hint: tr('sponsor.overview.options.single.hint', args: [onceTwoProduct.priceLabel])));

                    items.add(OfferItem(
                        id: onceOneProduct.id,
                        labelPrice: onceOneProduct.priceLabel,
                        labelType: tr('sponsor.overview.options.single.by'),
                        hint: tr('sponsor.overview.options.single.hint', args: [onceOneProduct.priceLabel])));
                  }

                  return OffersOfferState(
                      title: sponsorship.activeSubscriptionId != null
                          ? tr('sponsor.overview.options.title.extended')
                          : tr('sponsor.overview.options.title.new'),
                      isSponsorshipInfoVisible: sponsorship.value > 0,
                      sponsoredValue: "${sponsorship.value.round()} €",
                      activeSubscription:
                          sponsorship.activeSubscriptionId != null
                              ? [
                                  yearlySubscriptionProduct,
                                  monthlySubscriptionProduct
                                ]
                                  .firstWhereOrNull((element) =>
                                      element.id ==
                                      sponsorship.activeSubscriptionId)
                                  ?.title
                              : null,
                      items: items);
                }, (error) => ErrorOfferState(errorDetails: error.toString()));
              }, (error) => ErrorOfferState(errorDetails: error.toString()));
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
        return;
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

  void onRestoreClicked() {
    _productRepository.restore().listen((result) {
      if (isClosed) {
        return;
      }

      if (result.isError()) {
        emit(ErrorPurchaseLoadingOfferState(
            errorDetails: result.tryGetError()?.toString()));
        _fetchItems();
        return;
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
