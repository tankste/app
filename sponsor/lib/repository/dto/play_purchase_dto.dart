import 'package:sponsor/model/play_purchase_model.dart';
import 'package:sponsor/model/purchase_model.dart';

class PlayPurchaseDto {
  final String? provider;
  final String? productId;
  final String? token;
  final String? secret;

  PlayPurchaseDto({this.provider, this.productId, this.token, this.secret});

  factory PlayPurchaseDto.fromJson(Map<String, dynamic> parsedJson) {
    return PlayPurchaseDto(
      provider: parsedJson['provider'],
      productId: parsedJson['productId'],
      token: parsedJson['token'],
      secret: parsedJson['secret'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'productId': productId,
      'token': token,
      'secret': secret,
    };
  }

  factory PlayPurchaseDto.fromModel(PlayPurchaseModel model) {
    return PlayPurchaseDto(
      provider: model.provider == PurchaseProvider.playStore
          ? 'play_store'
          : model.provider == PurchaseProvider.appleStore
          ? 'apple_store'
          : null,
      productId: model.productId,
      token: model.token,
      secret: model.secret,
    );
  }

  PlayPurchaseModel toModel() {
    return PlayPurchaseModel(
      provider: provider == 'play_store'
          ? PurchaseProvider.playStore
          : provider == 'apple_store'
          ? PurchaseProvider.appleStore
          : PurchaseProvider.unknown,
      productId: productId ?? "",
      token: token ?? "",
      secret: secret ?? "",
    );
  }

  @override
  String toString() {
    return 'PlayPurchaseDto{provider: $provider, productId: $productId, token: $token, secret: $secret}';
  }
}
