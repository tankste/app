import 'package:sponsor/model/apple_purchase_model.dart';
import 'package:sponsor/model/purchase_model.dart';

class ApplePurchaseDto {
  final String? provider;
  final String? productId;
  final String? transactionId;
  final String? data;
  final String? deviceId;

  ApplePurchaseDto({this.provider, this.productId, this.transactionId, this.data, this.deviceId});

  factory ApplePurchaseDto.fromJson(Map<String, dynamic> parsedJson) {
    return ApplePurchaseDto(
      provider: parsedJson['provider'],
      productId: parsedJson['productId'],
      transactionId: parsedJson['transactionId'],
      data: parsedJson['data'],
      deviceId: parsedJson['deviceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'productId': productId,
      'transactionId': transactionId,
      'data': data,
      'deviceId': deviceId,
    };
  }

  factory ApplePurchaseDto.fromModel(
      ApplePurchaseModel model, String deviceId) {
    return ApplePurchaseDto(
      provider: model.provider == PurchaseProvider.playStore
          ? 'play_store'
          : model.provider == PurchaseProvider.appleStore
              ? 'apple_store'
              : null,
      productId: model.productId,
      transactionId: model.transactionId,
      data: model.data,
      deviceId: deviceId,
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
        transactionId: transactionId ?? "",
        data: data ?? "");
  }

  @override
  String toString() {
    return 'ApplePurchaseDto{provider: $provider, productId: $productId, transactionId: $transactionId, data: $data, deviceId: $deviceId}';
  }
}
