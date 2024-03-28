class CurrencyModel {
  final CurrencyType currency;
  final String symbol;
  final String label;

  CurrencyModel({required this.currency, required this.symbol, required this.label});

  factory CurrencyModel.unknown() {
    return CurrencyModel(
      currency: CurrencyType.unknown,
      symbol: "?",
      label: "Unknown",
    );
  }

  @override
  String toString() {
    return 'CurrencyModel{currency: $currency, symbol: $symbol, label: $label}';
  }
}

enum CurrencyType { unknown, eur, isk, chf, pln, dkk }
