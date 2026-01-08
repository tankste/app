class ProductModel {
  final String id;
  final String title;
  final String priceLabel;

  ProductModel({required this.id, required this.title, required this.priceLabel});

  @override
  String toString() {
    return 'ProductModel(id: $id, title: $title priceLabel: $priceLabel)';
  }
}