import 'dart:async';
import 'dart:ffi';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:sponsor_core/model/product_model.dart';
import 'package:sponsor_core/repository/product_repository.dart';

class StoreProductRepository extends ProductRepository {
  static final StoreProductRepository _singleton =
      StoreProductRepository._internal();

  factory StoreProductRepository() {
    return _singleton;
  }

  StoreProductRepository._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Future<Result<ProductModel, Exception>> getMonth() {
    return _fetchProduct("app.tankste.sponsor.sub.2026.monthly");
  }

  @override
  Future<Result<ProductModel, Exception>> getYear() {
    return _fetchProduct("app.tankste.sponsor.sub.2026.yearly");
  }

  Future<Result<ProductModel, Exception>> _fetchProduct(String id) {
    return _inAppPurchase.isAvailable().then((isAvailable) {
      if (isAvailable) {
        return _inAppPurchase
            .queryProductDetails({id})
            .then((response) => response.productDetails.firstOrNull)
            .then((details) => details != null
                ? Result<ProductModel, Exception>.success(ProductModel(
                    id: details.id,
                    title: details.title,
                    priceLabel: details.price))
                : Result<ProductModel, Exception>.error(
                    Exception("Product $id not found.")))
            .catchError((error) => Result<ProductModel, Exception>.error(
                Exception(error.toString)));
      } else {
        return Result<ProductModel, Exception>.error(
            Exception("Purchase unavailable"));
      }
    });
  }

  @override
  Stream<Result<bool, Exception>> purchaseMonth() {
    return _purchaseProduct("app.tankste.sponsor.sub.2026.monthly");
  }

  @override
  Stream<Result<bool, Exception>> purchaseYear() {
    return _purchaseProduct("app.tankste.sponsor.sub.2026.yearly");
  }

  Stream<Result<bool, Exception>> _purchaseProduct(String id) {
    StreamController<Result<bool, Exception>> resultController =
        StreamController.broadcast();
    _inAppPurchase.purchaseStream.listen((result) {
      PurchaseDetails details = result.first;
      if (details.status == PurchaseStatus.purchased) {
        if (details.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(details);
        }

        resultController.add(Result.success(true));
      } else if (details.status == PurchaseStatus.error) {
        resultController.add(Result.error(Exception(details.error?.message)));
      } else if (details.status == PurchaseStatus.canceled) {
        resultController.add(Result.success(false));
      }
    });

    _inAppPurchase
        .queryProductDetails({id})
        .then((response) => response.productDetails.first)
        .then((details) {
          PurchaseParam param = PurchaseParam(productDetails: details);
          return _inAppPurchase.buyNonConsumable(purchaseParam: param);
        });

    return resultController.stream;
  }

  @override
  bool hasProducts() {
    return true;
  }
}

