import 'package:station/model/fuel_type.dart';

class PriceModel {
  final int id;
  final int originId;
  final FuelType fuelType;
  final double? price;
  final String label;
  final DateTime? lastChangedDate;

  PriceModel(
      {required this.id,
      required this.originId,
      required this.fuelType,
      required this.price,
      required this.label,
      required this.lastChangedDate});

  @override
  String toString() {
    return 'PriceModel{id: $id, originId: $originId, fuelType: $fuelType, price: $price, label: $label, lastChangedDate: $lastChangedDate}';
  }
}
