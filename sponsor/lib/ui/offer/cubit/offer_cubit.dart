import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/repository/product_repository.dart';
import 'package:sponsor/ui/offer/cubit/offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  final ProductRepository _productRepository =
      SponsorModuleFactory.createProductRepository();

  OfferCubit() : super(LoadingOfferState()) {
    _fetchItems();
  }

  void _fetchItems() {
    emit(LoadingOfferState());

    CombineLatestStream.combine3(
        _productRepository.get('app.tankste.sponsor.sub.yearly.12'),
        _productRepository.get('app.tankste.sponsor.sub.monthly.2'),
        _productRepository.get('app.tankste.sponsor.product.10'),
        (yearlySubscriptionProductResult, monthlySubscriptionProductResult,
            onceTenProductResult) {
      return yearlySubscriptionProductResult.when((yearlySubscriptionProduct) {
        return monthlySubscriptionProductResult.when(
            (monthlySubscriptionProduct) {
          return onceTenProductResult.when((onceTenProduct) {
            return OffersOfferState(items: [
              OfferItem(
                  labelPrice: yearlySubscriptionProduct.priceLabel,
                  labelType: "/ Jährlich",
                  hint:
                      "Unterstütze tankste! mit einer jährlichen Zahlung von ${yearlySubscriptionProduct.priceLabel}."),
              OfferItem(
                  labelPrice: monthlySubscriptionProduct.priceLabel,
                  labelType: "/ Monatlich",
                  hint:
                      "Unterstütze tankste! mit einer monatlichen Zahlung von ${monthlySubscriptionProduct.priceLabel}."),
              OfferItem(
                  labelPrice: onceTenProduct.priceLabel,
                  labelType: "/ Einmalig",
                  hint:
                      "Unterstütze tankste! mit einer einmaligen Zahlung von ${onceTenProduct.priceLabel}.")
            ]);
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

  void onRetryClicked() {
    _fetchItems();
  }
}
