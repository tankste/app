import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/repository/product_repository.dart';
import 'package:sponsor/ui/overview/cubit/overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  final BalanceRepository _balanceRepository =
      SponsorModuleFactory.createBalanceRepository();

  final ProductRepository _productRepository =
      SponsorModuleFactory.createProductRepository();

  OverviewCubit() : super(LoadingOverviewState()) {
    _fetchBalance();
  }

  void _fetchBalance() {
    emit(LoadingOverviewState());

    _balanceRepository
        .get()
        .first // TODO: use stream
        .then((result) {
      if (isClosed) {
        return;
      }

      emit(result.when((balance) {
        return BalanceOverviewState(
            gaugePercentage: balance.spent > 0
                ? (balance.earned / balance.spent * 100).round()
                : 100,
            balance:
                "${balance.earned.round()} € von ${balance.spent.round()} €");
      }, (error) => ErrorOverviewState(errorDetails: error.toString())));
    });
  }

  void onRetryClicked() {
    _fetchBalance();
  }
}
