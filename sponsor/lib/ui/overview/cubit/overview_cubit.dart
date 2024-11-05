import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/di/sponsor_module_factory.dart';
import 'package:sponsor/model/balance_model.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/ui/overview/cubit/overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  final BalanceRepository _balanceRepository =
      SponsorModuleFactory.createBalanceRepository();

  StreamSubscription<Result<BalanceModel, Exception>>?
      _balanceStreamSubscription;

  OverviewCubit() : super(LoadingOverviewState()) {
    _fetchBalance();
  }

  void _fetchBalance() {
    emit(LoadingOverviewState());

    _balanceStreamSubscription?.cancel();
    _balanceStreamSubscription = _balanceRepository.get().listen((result) {
      if (isClosed) {
        return;
      }

      emit(result.when((balance) {
        return BalanceOverviewState(
            gaugePercentage: balance.spent > 0
                ? (balance.earned / balance.spent * 100).round()
                : 100,
            balance: tr('sponsor.overview.balance', args: [balance.earned.round().toString(), balance.spent.round().toString()]));
      }, (error) => ErrorOverviewState(errorDetails: error.toString())));
    });
  }

  void onRetryClicked() {
    _fetchBalance();
  }
}
