class ProductModel {
  final String id;
  final String title;
  final String description;
  final String priceLabel;
  final double price;

  ProductModel({required this.id, required this.title, required this.description, required this.priceLabel, required this.price});

  @override
  String toString() {
    return 'ProductModel{id: $id, title: $title, description: $description, priceLabel: $priceLabel, price: $price}';
  }
}
