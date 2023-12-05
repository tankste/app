import 'package:sponsor/model/purchase_model.dart';

class PlayPurchaseModel extends PurchaseModel {
  final String token;
  final String secret;

  PlayPurchaseModel(
      {required this.token,
      required this.secret,
      required super.productId,
      required super.provider});

  @override
  String toString() {
    return 'PlayPurchaseModel{token: $token, secret: $secret, productId: $productId, provider: $provider}';
  }
}
