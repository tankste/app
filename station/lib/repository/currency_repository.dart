import 'dart:async';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/model/currency_model.dart';

abstract class CurrencyRepository {
  Stream<Result<List<CurrencyModel>, Exception>> list();

  Stream<Result<CurrencyModel, Exception>> getSelected();

  Stream<Result<CurrencyModel, Exception>> setSelected(CurrencyModel currency);
}

class LocalCurrencyRepository extends CurrencyRepository {
  static final LocalCurrencyRepository _instance =
      LocalCurrencyRepository._internal();

  factory LocalCurrencyRepository() {
    return _instance;
  }

  LocalCurrencyRepository._internal();

  final StreamController<Result<CurrencyModel, Exception>>
      _getSelectedStreamController = StreamController.broadcast();

  @override
  Stream<Result<List<CurrencyModel>, Exception>> list() {
    return Stream.value(Result.success([
      CurrencyModel(
          currency: CurrencyType.eur,
          symbol: "€",
          label: tr('generic.currency.eur.label'),
          exchangeRates: {
            CurrencyType.eur: 1.0,
            CurrencyType.isk: 150.3,
            // CurrencyType.chf: 0.97,
            // CurrencyType.pln: 4.31,
            // CurrencyType.dkk: 7.46
          }),
      // CurrencyModel(
      //     currency: CurrencyType.chf,
      //     symbol: "Fr",
      //     label: tr('generic.currency.chf.label'),
      //     exchangeRates: {
      //       CurrencyType.eur: 0,
      //       CurrencyType.isk: 0,
      //       CurrencyType.chf: 1.0,
      //       CurrencyType.pln: 0,
      //       CurrencyType.dkk: 0,
      //     }),
      // CurrencyModel(
      //     currency: CurrencyType.dkk,
      //     symbol: "dkr",
      //     label: tr('generic.currency.dkk.label'),
      //     exchangeRates: {
      //       CurrencyType.eur: 0,
      //       CurrencyType.isk: 0,
      //       CurrencyType.chf: 0,
      //       CurrencyType.pln: 0,
      //       CurrencyType.dkk: 1.0
      //     }),
      // CurrencyModel(
      //     currency: CurrencyType.pln,
      //     symbol: "zł",
      //     label: tr('generic.currency.pln.label'),
      //     exchangeRates: {
      //       CurrencyType.eur: 0,
      //       CurrencyType.isk: 0,
      //       CurrencyType.chf: 0,
      //       CurrencyType.pln: 1.0,
      //       CurrencyType.dkk: 0,
      //     }),
      CurrencyModel(
          currency: CurrencyType.isk,
          symbol: "ikr",
          label: tr('generic.currency.isk.label'),
          exchangeRates: {
            CurrencyType.eur: 0.0067,
            CurrencyType.isk: 1.0,
            // CurrencyType.chf: 0.0065,
            // CurrencyType.pln: 0.029,
            // CurrencyType.dkk: 0.050,
          }),
    ]));
  }

  @override
  Stream<Result<CurrencyModel, Exception>> getSelected() {
    _getSelectedAsync().then((result) {
      _getSelectedStreamController.add(result);
    });

    return _getSelectedStreamController.stream;
  }

  Future<Result<CurrencyModel, Exception>> _getSelectedAsync() async {
    try {
      //TODO: select default currency based on country
      List<CurrencyModel> currencies = (await list().first).tryGetSuccess()!;
      CurrencyModel defaultCurrency = currencies.firstWhereOrNull((currency) =>
              currency.currency.name == tr('generic.currency.default')) ??
          currencies.first;

      SharedPreferences preferences = await _getPreferences();
      if (preferences.containsKey('currency')) {
        String? currencyTypeString = preferences.getString('currency');
        CurrencyModel? currency = currencies.firstWhereOrNull(
            (currency) => currency.currency.name == currencyTypeString);
        return Result.success(currency ?? defaultCurrency);
      } else {
        return Result.success(defaultCurrency);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<CurrencyModel, Exception>> setSelected(CurrencyModel currency) {
    StreamController<Result<CurrencyModel, Exception>> streamController =
        StreamController.broadcast();

    _setSelectedAsync(currency)
        .then((result) => streamController.add(result))
        .then((_) => getSelected());

    return streamController.stream;
  }

  Future<Result<CurrencyModel, Exception>> _setSelectedAsync(
      CurrencyModel currency) async {
    try {
      SharedPreferences preferences = await _getPreferences();
      await preferences.setString('currency', currency.currency.name);

      return Result.success(currency);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
