import 'package:station/model/currency_model.dart';

class PriceModel {
  final int id;
  final int originId;
  final FuelType fuelType;
  final double price;
  final CurrencyModel currency;
  final DateTime? lastChangedDate;

  PriceModel(
      {required this.id,
      required this.originId,
      required this.fuelType,
      required this.price,
      required this.currency,
      required this.lastChangedDate});

  @override
  String toString() {
    return 'PriceModel{id: $id, originId: $originId, fuelType: $fuelType, price: $price, currency: $currency, lastChangedDate: $lastChangedDate}';
  }
}

enum FuelType {
  unknown,
  e5,
  e10,
  diesel,
}
