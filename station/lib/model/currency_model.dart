class CurrencyModel {
  final CurrencyType currency;
  final String symbol;
  final String label;

  CurrencyModel({required this.currency, required this.symbol, required this.label});

  @override
  String toString() {
    return 'CurrencyModel{currency: $currency, symbol: $symbol, label: $label}';
  }
}

enum CurrencyType { unknown, eur, isk, chf, pln, dkk }
