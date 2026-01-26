class CurrencyModel {
  final CurrencyType currency;
  final String symbol;
  final String label;
  final Map<CurrencyType, double> exchangeRates;

  CurrencyModel(
      {required this.currency,
      required this.symbol,
      required this.label,
      required this.exchangeRates});

  factory CurrencyModel.unknown() {
    return CurrencyModel(
      currency: CurrencyType.unknown,
      symbol: "?",
      label: "Unknown",
      exchangeRates: {},
    );
  }

  double? convertTo(double? amount, CurrencyType targetCurrency) {
    if (amount != null && exchangeRates.containsKey(targetCurrency)) {
      return amount * exchangeRates[targetCurrency]!;
    }

    return null;
  }

  @override
  String toString() {
    return 'CurrencyModel{currency: $currency, symbol: $symbol, label: $label, exchangeRates: $exchangeRates}';
  }
}

enum CurrencyType {
  unknown,
  eur,
  isk,
  dkk,
}
