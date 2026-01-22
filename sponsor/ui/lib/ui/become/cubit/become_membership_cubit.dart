import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_core/model/product_model.dart';
import 'package:sponsor_core/model/provider_model.dart';
import 'package:sponsor_core/repository/product_repository.dart';
import 'package:sponsor_core/repository/provider_repository.dart';
import 'package:sponsor_data/di/sponsor_data_module_factory.dart';
import 'package:sponsor_ui/ui/become/cubit/become_membership_state.dart';

class BecomeMembershipCubit extends Cubit<BecomeMembershipState> {
  final ProductRepository _productRepository =
      SponsorDataModuleFactory.createProductRepository();
  final ProviderRepository _providerRepository =
      SponsorDataModuleFactory.createProviderRepository();

  BecomeMembershipCubit() : super(LoadingBecomeMembershipState()) {
    _fetch();
  }

  void _fetch() {
    if (_productRepository.hasProducts()) {
      _fetchYearProduct();
    } else {
      _fetchProviders();
    }
  }

  void _fetchYearProduct() {
    emit(LoadingBecomeMembershipState());

    _productRepository.getYear().then((result) {
      if (isClosed) {
        return;
      }

      result.when((yearProduct) => _fetchMonthProduct(yearProduct),
          (error) => emit(ErrorBecomeMembershipState()));
    });
  }

  void _fetchMonthProduct(ProductModel yearProduct) {
    emit(LoadingBecomeMembershipState());

    _productRepository.getMonth().then((result) {
      if (isClosed) {
        return;
      }

      emit(result.when(
          (monthProduct) => ProductsBecomeMembershipState(
                yearPrice:
                    yearProduct.priceLabel + tr('sponsor.product.year.by'),
                monthPrice:
                    monthProduct.priceLabel + tr('sponsor.product.month.by'),
              ),
          (error) => ErrorBecomeMembershipState()));
    });
  }

  void _fetchProviders() {
    List<ProviderModel> providers = _providerRepository.list();
    emit(ProvidersBecomeMembershipState(
        providers: providers
            .map((provider) => BecomeMembershipProvider(
                label: provider.name, logoName: provider.logoName, url: provider.url))
            .toList(growable: false)));
  }

  void onBuyYearSubscriptionClicked() {
    emit(LoadingBecomeMembershipState());

    _productRepository.purchaseYear().listen((result) {
      if (isClosed) {
        return;
      }

      result.when((hasBought) {
        if (hasBought) {
          emit(BoughtBecomeMembershipState());
        } else {
          _fetchYearProduct();
        }
      }, (error) => {_fetchYearProduct()});
    });
  }

  void onBuyMonthSubscriptionClicked() {
    emit(LoadingBecomeMembershipState());

    _productRepository.purchaseMonth().listen((result) {
      if (isClosed) {
        return;
      }

      result.when((hasBought) {
        if (hasBought) {
          emit(BoughtBecomeMembershipState());
        } else {
          _fetchYearProduct();
        }
      }, (error) => {_fetchYearProduct()});
    });
  }
}
