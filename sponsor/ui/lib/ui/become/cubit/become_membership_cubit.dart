import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sponsor_core/model/product_model.dart';
import 'package:sponsor_core/repository/product_repository.dart';
import 'package:sponsor_data_closed/repository/store_product_repository.dart';
import 'package:sponsor_ui/ui/become/cubit/become_membership_state.dart';

class BecomeMembershipCubit extends Cubit<BecomeMembershipState> {
  final ProductRepository _productRepository = StoreProductRepository();

  BecomeMembershipCubit() : super(LoadingBecomeMembershipState()) {
    _fetchYearProduct();
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
}
