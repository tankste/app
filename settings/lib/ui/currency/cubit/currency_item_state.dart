import 'package:core/cubit/base_state.dart';
import 'package:settings/model/map_destination_model.dart';
import 'package:station/model/currency_model.dart';

abstract class CurrencyItemState {}

class LoadingCurrencyItemState extends CurrencyItemState {}

class ValueCurrencyItemState extends CurrencyItemState {
  final String valueLabel;
  final CurrencyType currencyType;
  final List<CurrencyModel> availableCurrencies;

  ValueCurrencyItemState({
    required this.valueLabel,
    required this.currencyType,
    required this.availableCurrencies,
  });
}

class ErrorCurrencyItemState extends CurrencyItemState {
  final String errorDetails;

  ErrorCurrencyItemState({required this.errorDetails});
}
