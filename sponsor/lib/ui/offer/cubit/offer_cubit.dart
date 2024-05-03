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

    CombineLatestStream.combine7(
        _sponsorshipRepository.get(),
        _productRepository.get('app.tankste.sponsor.product.50'),
        _productRepository.get('app.tankste.sponsor.product.20'),
        _productRepository.get('app.tankste.sponsor.product.10'),
        _productRepository.get('app.tankste.sponsor.product.5'),
        _productRepository.get('app.tankste.sponsor.product.2'),
        _productRepository.get('app.tankste.sponsor.product.1'),
        (sponsorshipResult,
            onceFiftyProductResult,
            onceTwentyProductResult,
            onceTenProductResult,
            onceFiveProductResult,
            onceTwoProductResult,
            onceOneProductResult) {
      return sponsorshipResult.when((sponsorship) {
        return onceFiftyProductResult.when((onceFiftyProduct) {
          return onceTwentyProductResult.when((onceTwentyProduct) {
            return onceTenProductResult.when((onceTenProduct) {
              return onceFiveProductResult.when((onceFiveProduct) {
                return onceTwoProductResult.when((onceTwoProduct) {
                  return onceOneProductResult.when((onceOneProduct) {
                    List<OfferItem> items = [
                      OfferItem(
                          id: onceFiftyProduct.id,
                          labelPrice: onceFiftyProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceFiftyProduct.priceLabel])),
                      OfferItem(
                          id: onceTwentyProduct.id,
                          labelPrice: onceTwentyProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceTwentyProduct.priceLabel])),
                      OfferItem(
                          id: onceTenProduct.id,
                          labelPrice: onceTenProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceTenProduct.priceLabel])),
                      OfferItem(
                          id: onceFiveProduct.id,
                          labelPrice: onceFiveProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceFiveProduct.priceLabel])),
                      OfferItem(
                          id: onceTwoProduct.id,
                          labelPrice: onceTwoProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceTwoProduct.priceLabel])),
                      OfferItem(
                          id: onceOneProduct.id,
                          labelPrice: onceOneProduct.priceLabel,
                          labelType: tr('sponsor.overview.options.single.by'),
                          hint: tr('sponsor.overview.options.single.hint',
                              args: [onceOneProduct.priceLabel])),
                    ];

                    return OffersOfferState(
                        title: tr('sponsor.overview.options.title.new'),
                        isSponsorshipInfoVisible: sponsorship.value > 0,
                        sponsoredValue: "${sponsorship.value.round()} €",
                        activeSubscription: null,
                        items: items);
                  },
                      (error) =>
                          ErrorOfferState(errorDetails: error.toString()));
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
