import 'dart:async';
import 'dart:io';

import 'package:core/device/model/device_model.dart';
import 'package:core/device/repository/device_repository.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor/model/apple_purchase_model.dart';
import 'package:sponsor/model/play_purchase_model.dart';
import 'package:sponsor/model/product_model.dart';
import 'package:sponsor/model/purchase_model.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/repository/comment_repository.dart';
import 'package:sponsor/repository/purchase_repository.dart';

abstract class ProductRepository {
  Stream<Result<ProductModel, Exception>> get(String id);

  Stream<Result<void, Exception>> purchase(String id);

  Stream<Result<void, Exception>> restore();
}

class MobileProductRepository extends ProductRepository {
  static final MobileProductRepository _instance =
      MobileProductRepository._internal();

  late PurchaseRepository _purchaseRepository;
  late DeviceRepository _deviceRepository;
  late BalanceRepository _balanceRepository;
  late CommentRepository _commentRepository;

  factory MobileProductRepository(
      PurchaseRepository purchaseRepository,
      DeviceRepository deviceRepository,
      BalanceRepository balanceRepository,
      CommentRepository commentRepository) {
    _instance._purchaseRepository = purchaseRepository;
    _instance._deviceRepository = deviceRepository;
    _instance._balanceRepository = balanceRepository;
    _instance._commentRepository = commentRepository;
    return _instance;
  }

  MobileProductRepository._internal();

  final Map<String, StreamController<Result<ProductModel, Exception>>>
      _getStreamController = {};

  @override
  Stream<Result<ProductModel, Exception>> get(String id) {
    if (!_getStreamController.containsKey(id)) {
      _getStreamController[id] = StreamController.broadcast();
    }

    _getAsync(id).then((result) => _getStreamController[id]!.add(result));

    return _getStreamController[id]!.stream;
  }

  Future<Result<ProductModel, Exception>> _getAsync(String id) async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) {
        return Result.error(Exception("InAppPurchase is not available"));
      }

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails({id});

      if (response.notFoundIDs.isNotEmpty) {
        return Result.error(Exception(
            "Product '$id' not found. Reason: ${response.error?.message}"));
      }

      ProductDetails productDto = response.productDetails.first;
      ProductModel product = ProductModel(
        id: productDto.id,
        title: productDto.title,
        description: productDto.description,
        priceLabel: productDto.price,
        price: productDto.rawPrice,
      );
      return Result.success(product);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<void, Exception>> purchase(String id) {
    StreamController<Result<void, Exception>> streamController =
        StreamController.broadcast();

    _purchaseAsync(id)
        .then((result) => streamController.add(result))
        .then((_) => _balanceRepository.get())
        .then((_) => _commentRepository.list())
        .then((_) => _commentRepository.getOwn());

    return streamController.stream;
  }

  Future<Result<void, Exception>> _purchaseAsync(String id) async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) {
        return Result.error(Exception("InAppPurchase is not available"));
      }

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails({id});
      ProductDetails productDetails = response.productDetails.first;

      Result<DeviceModel, Exception> deviceResult =
          await _deviceRepository.get().first;
      if (deviceResult.isError()) {
        return Result.error(deviceResult.tryGetError()!);
      }
      DeviceModel device = deviceResult.tryGetSuccess()!;

      if (id.contains("subscription")) {
        InAppPurchase.instance.buyNonConsumable(
            purchaseParam: PurchaseParam(
                productDetails: productDetails,
                applicationUserName: device.id));
      } else {
        InAppPurchase.instance.buyConsumable(
            purchaseParam: PurchaseParam(
                productDetails: productDetails, applicationUserName: device.id),
            autoConsume: Platform.isIOS);
      }

      Result<PurchaseDetails, Exception> purchaseDetailsResult =
          await _waitForPurchaseResultAsync();

      if (purchaseDetailsResult.isError()) {
        return Result.error(purchaseDetailsResult.tryGetError()!);
      }

      PurchaseDetails purchaseDetails = purchaseDetailsResult.tryGetSuccess()!;
      if (purchaseDetails is GooglePlayPurchaseDetails) {
        return _purchaseRepository
            .create(PlayPurchaseModel(
                token: purchaseDetails.billingClientPurchase.orderId,
                secret: purchaseDetails.billingClientPurchase.purchaseToken,
                productId: purchaseDetails.productID,
                provider: PurchaseProvider.playStore))
            .first;
      } else if (purchaseDetails is AppStorePurchaseDetails) {
        return _purchaseRepository
            .create(ApplePurchaseModel(
                data: purchaseDetails.verificationData.serverVerificationData,
                productId: purchaseDetails.productID,
                provider: PurchaseProvider.appleStore))
            .first;
      } else {
        return Result.error(Exception("Unsupported purchase details!"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<void, Exception>> restore() {
    StreamController<Result<void, Exception>> streamController =
        StreamController.broadcast();

    _restoreAsync().then((result) => streamController.add(result));

    return streamController.stream;
  }

  Future<Result<void, Exception>> _restoreAsync() async {
    try {
      if (!await InAppPurchase.instance.isAvailable()) {
        return Result.error(Exception("InAppPurchase is not available"));
      }

      InAppPurchase.instance.restorePurchases();

      Result<PurchaseDetails, Exception> purchaseDetailsResult =
          await _waitForPurchaseResultAsync();
      if (purchaseDetailsResult.isError()) {
        return Result.error(purchaseDetailsResult.tryGetError()!);
      }

      PurchaseDetails purchaseDetails = purchaseDetailsResult.tryGetSuccess()!;
      if (purchaseDetails is GooglePlayPurchaseDetails) {
        return _purchaseRepository
            .create(PlayPurchaseModel(
                token: purchaseDetails.billingClientPurchase.orderId,
                secret: purchaseDetails.billingClientPurchase.purchaseToken,
                productId: purchaseDetails.productID,
                provider: PurchaseProvider.playStore))
            .first;
      } else {
        return Result.error(Exception("Unsupported purchase details!"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<PurchaseDetails, Exception>>
      _waitForPurchaseResultAsync() async {
    try {
      final List<PurchaseDetails> purchaseDetailsList =
          await InAppPurchase.instance.purchaseStream.first;
      final PurchaseDetails purchaseDetails = purchaseDetailsList.first;
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          return Future.delayed(const Duration(milliseconds: 1000), () {
            return _waitForPurchaseResultAsync();
          });
        case PurchaseStatus.purchased:
          InAppPurchase.instance.completePurchase(purchaseDetails);
          return Result.success(purchaseDetails);
        case PurchaseStatus.error:
          InAppPurchase.instance.completePurchase(purchaseDetails);
          return Result.error(
              Exception("Purchase error: ${purchaseDetails.error}"));
        case PurchaseStatus.restored:
          InAppPurchase.instance.completePurchase(purchaseDetails);
          return Result.success(purchaseDetails);
        case PurchaseStatus.canceled:
          InAppPurchase.instance.completePurchase(purchaseDetails);
          return Result.error(Exception("Purchase error: Canceled"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
