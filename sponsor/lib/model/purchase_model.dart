abstract class PurchaseModel {
  final PurchaseProvider provider;
  final String productId;

  PurchaseModel({required this.provider, required this.productId});

  @override
  String toString() {
    return 'PurchaseModel{provider: $provider, productId: $productId}';
  }
}

enum PurchaseProvider { unknown, playStore, appleStore }
