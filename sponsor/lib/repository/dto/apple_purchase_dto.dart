import 'package:sponsor/model/apple_purchase_model.dart';
import 'package:sponsor/model/purchase_model.dart';

class ApplePurchaseDto {
  final String? provider;
  final String? productId;
  final String? data;

  ApplePurchaseDto({this.provider, this.productId, this.data});

  factory ApplePurchaseDto.fromJson(Map<String, dynamic> parsedJson) {
    return ApplePurchaseDto(
      provider: parsedJson['provider'],
      productId: parsedJson['productId'],
      data: parsedJson['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'productId': productId,
      'data': data,
    };
  }

  factory ApplePurchaseDto.fromModel(ApplePurchaseModel model) {
    return ApplePurchaseDto(
      provider: model.provider == PurchaseProvider.playStore
          ? 'play_store'
          : model.provider == PurchaseProvider.appleStore
          ? 'apple_store'
          : null,
      productId: model.productId,
      data: model.data,
    );
  }

  ApplePurchaseModel toModel() {
    return ApplePurchaseModel(
      provider: provider == 'play_store'
          ? PurchaseProvider.playStore
          : provider == 'apple_store'
          ? PurchaseProvider.appleStore
          : PurchaseProvider.unknown,
      productId: productId ?? "",
      data: data ?? "",
    );
  }

  @override
  String toString() {
    return 'ApplePurchaseDto{provider: $provider, productId: $productId, data: $data}';
  }
}
