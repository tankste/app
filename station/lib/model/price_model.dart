class PriceModel {
  final int id;
  final FuelType fuelType;
  final double price;
  final DateTime? lastChangedDate;

  PriceModel(
      {required this.id,
      required this.fuelType,
      required this.price,
      required this.lastChangedDate});

  @override
  String toString() {
    return 'PriceModel{id: $id, fuelType: $fuelType, price: $price, lastChangedDate: $lastChangedDate}';
  }
}

enum FuelType {
  unknown,
  e5,
  e10,
  diesel,
}
