import 'package:sponsor/model/purchase_model.dart';

class ApplePurchaseModel extends PurchaseModel {
  final String transactionId;
  final String data;

  ApplePurchaseModel(
      {required this.transactionId, required this.data, required super.productId, required super.provider});

  @override
  String toString() {
    return 'ApplePurchaseModel{transactionId: $transactionId, data: $data, productId: $productId, provider: $provider}';
  }
}
