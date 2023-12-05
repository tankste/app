import 'package:sponsor/model/purchase_model.dart';

class ApplePurchaseModel extends PurchaseModel {
  final String data;

  ApplePurchaseModel(
      {required this.data, required super.productId, required super.provider});

  @override
  String toString() {
    return 'ApplePurchaseModel{data: $data, productId: $productId, provider: $provider}';
  }
}
