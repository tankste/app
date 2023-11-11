class PriceModel {
  final int id;
  final double e5Price;
  final double e10Price;
  final double dieselPrice;

  PriceModel(
      {required this.id,
      required this.e5Price,
      required this.e10Price,
      required this.dieselPrice});

  @override
  String toString() {
    return 'PriceModel{id: $id, e5Price: $e5Price, e10Price: $e10Price, dieselPrice: $dieselPrice}';
  }
}
