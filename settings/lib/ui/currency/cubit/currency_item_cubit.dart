import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:settings/ui/currency/cubit/currency_item_state.dart';
import 'package:station/di/station_module_factory.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/repository/currency_repository.dart';

class CurrencyItemCubit extends Cubit<CurrencyItemState> {
  final CurrencyRepository _currencyRepository =
      StationModuleFactory.createCurrencyRepository();

  StreamSubscription<CurrencyItemState>? _currenciesSubscription;

  CurrencyItemCubit() : super(LoadingCurrencyItemState()) {
    _fetchCurrencies();
  }

  void _fetchCurrencies() {
    emit(LoadingCurrencyItemState());

    _currenciesSubscription?.cancel();
    _currenciesSubscription = CombineLatestStream.combine2(
        _currencyRepository.list(), _currencyRepository.getSelected(),
        (availableCurrenciesResult, selectedCurrencyResult) {
      return availableCurrenciesResult.when((availableCurrencies) {
        return selectedCurrencyResult.when((selectedCurrency) {
          return ValueCurrencyItemState(
              valueLabel:
                  "${selectedCurrency.label} (${selectedCurrency.symbol})",
              currencyType: selectedCurrency.currency,
              availableCurrencies: availableCurrencies);
        }, (error) => ErrorCurrencyItemState(errorDetails: error.toString()));
      }, (error) => ErrorCurrencyItemState(errorDetails: error.toString()));
    }).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }

  void onRetryClicked() {
    _fetchCurrencies();
  }

  void onCurrencyChanged(CurrencyModel currency) {
    _currencyRepository.setSelected(currency);
  }
}
