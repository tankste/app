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
}

// abstract class ProductRepository {
//   Stream<Result<ProductModel, Exception>> get(String id);
//
//   Stream<Result<void, Exception>> purchase(String id);
//
//   Stream<Result<void, Exception>> restore();
// }
//
// class MobileProductRepository extends ProductRepository {
//   static final MobileProductRepository _instance =
//   MobileProductRepository._internal();
//
//   late PurchaseRepository _purchaseRepository;
//   late DeviceRepository _deviceRepository;
//   late BalanceRepository _balanceRepository;
//   late CommentRepository _commentRepository;
//   late SponsorshipRepository _sponsorshipRepository;
//   late TransactionDeviceRepository _transactionDeviceRepository;
//
//   factory MobileProductRepository(
//       PurchaseRepository purchaseRepository,
//       DeviceRepository deviceRepository,
//       BalanceRepository balanceRepository,
//       CommentRepository commentRepository,
//       SponsorshipRepository sponsorshipRepository,
//       TransactionDeviceRepository transactionDeviceRepository,
//       ) {
//     _instance._purchaseRepository = purchaseRepository;
//     _instance._deviceRepository = deviceRepository;
//     _instance._balanceRepository = balanceRepository;
//     _instance._commentRepository = commentRepository;
//     _instance._sponsorshipRepository = sponsorshipRepository;
//     _instance._transactionDeviceRepository = transactionDeviceRepository;
//     return _instance;
//   }
//
//   MobileProductRepository._internal();
//
//   final Map<String, StreamController<Result<ProductModel, Exception>>>
//   _getStreamController = {};
//
//   @override
//   Stream<Result<ProductModel, Exception>> get(String id) {
//     if (!_getStreamController.containsKey(id)) {
//       _getStreamController[id] = StreamController.broadcast();
//     }
//
//     _getAsync(id).then((result) => _getStreamController[id]!.add(result));
//
//     return _getStreamController[id]!.stream;
//   }
//
//   Future<Result<ProductModel, Exception>> _getAsync(String id) async {
//     try {
//       if (!await InAppPurchase.instance.isAvailable()) {
//         Exception error = Exception("InAppPurchase is not available");
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       final ProductDetailsResponse response =
//       await InAppPurchase.instance.queryProductDetails({id});
//
//       if (response.notFoundIDs.isNotEmpty) {
//         Exception error = Exception(
//             "Product '$id' not found. Reason: ${response.error?.message}");
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       ProductDetails productDto = response.productDetails.first;
//       ProductModel product = ProductModel(
//         id: productDto.id,
//         title: productDto.title,
//         description: productDto.description,
//         priceLabel: productDto.price,
//         price: productDto.rawPrice,
//       );
//       return Result.success(product);
//     } on Exception catch (e) {
//       Log.exception(e);
//       return Result.error(e);
//     }
//   }
//
//   @override
//   Stream<Result<void, Exception>> purchase(String id) {
//     StreamController<Result<void, Exception>> streamController =
//     StreamController.broadcast();
//
//     _purchaseAsync(id)
//         .then((result) => streamController.add(result))
//         .then((_) => _balanceRepository.get())
//         .then((_) => _commentRepository.list())
//         .then((_) => _commentRepository.getOwn())
//         .then((_) => _sponsorshipRepository.get());
//
//     return streamController.stream;
//   }
//
//   Future<Result<void, Exception>> _purchaseAsync(String id) async {
//     try {
//       if (!await InAppPurchase.instance.isAvailable()) {
//         Exception error = Exception("InAppPurchase is not available");
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       final ProductDetailsResponse response =
//       await InAppPurchase.instance.queryProductDetails({id});
//       ProductDetails productDetails = response.productDetails.first;
//
//       Result<DeviceModel, Exception> deviceResult =
//       await _deviceRepository.get().first;
//       if (deviceResult.isError()) {
//         Exception error = Exception(deviceResult.tryGetError()!);
//         Log.exception(error);
//         return Result.error(error);
//       }
//       DeviceModel device = deviceResult.tryGetSuccess()!;
//
//       if (id.contains("subscription")) {
//         InAppPurchase.instance.buyNonConsumable(
//             purchaseParam: PurchaseParam(
//                 productDetails: productDetails,
//                 applicationUserName: device.id));
//       } else {
//         InAppPurchase.instance.buyConsumable(
//             purchaseParam: PurchaseParam(
//                 productDetails: productDetails, applicationUserName: device.id),
//             autoConsume: Platform.isIOS);
//       }
//
//       Result<PurchaseDetails, Exception> purchaseDetailsResult =
//       await _waitForPurchaseResultAsync();
//
//       if (purchaseDetailsResult.isError()) {
//         Exception error = purchaseDetailsResult.tryGetError()!;
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       PurchaseDetails purchaseDetails = purchaseDetailsResult.tryGetSuccess()!;
//       if (purchaseDetails is GooglePlayPurchaseDetails) {
//         return _purchaseRepository
//             .create(PlayPurchaseModel(
//             token: purchaseDetails.billingClientPurchase.orderId,
//             secret: purchaseDetails.billingClientPurchase.purchaseToken,
//             productId: purchaseDetails.productID,
//             provider: PurchaseProvider.playStore))
//             .first;
//       } else if (purchaseDetails is AppStorePurchaseDetails) {
//         return _purchaseRepository
//             .create(ApplePurchaseModel(
//             transactionId: purchaseDetails.skPaymentTransaction.transactionIdentifier ?? "",
//             data: purchaseDetails.verificationData.serverVerificationData,
//             productId: purchaseDetails.productID,
//             provider: PurchaseProvider.appleStore))
//             .first;
//       } else {
//         Exception error = Exception("Unsupported purchase details!");
//         Log.exception(error);
//         return Result.error(error);
//       }
//     } on Exception catch (e) {
//       Log.exception(e);
//       return Result.error(e);
//     }
//   }
//
//   @override
//   Stream<Result<void, Exception>> restore() {
//     StreamController<Result<void, Exception>> streamController =
//     StreamController.broadcast();
//
//     _restoreAsync().then((result) => streamController.add(result));
//
//     return streamController.stream;
//   }
//
//   Future<Result<void, Exception>> _restoreAsync() async {
//     try {
//       if (!await InAppPurchase.instance.isAvailable()) {
//         Exception error = Exception("InAppPurchase is not available");
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       InAppPurchase.instance.restorePurchases();
//
//       Result<PurchaseDetails, Exception> purchaseDetailsResult =
//       await _waitForPurchaseResultAsync();
//       if (purchaseDetailsResult.isError()) {
//         Exception error = purchaseDetailsResult.tryGetError()!;
//         Log.exception(error);
//         return Result.error(error);
//       }
//
//       PurchaseDetails purchaseDetails = purchaseDetailsResult.tryGetSuccess()!;
//       if (purchaseDetails is GooglePlayPurchaseDetails) {
//         // TODO
//         // This is not required for Google. But be fair and add this later :-)
//         Exception error = Exception("Unsupported purchase details!");
//         Log.exception(error);
//         return Result.error(error);
//       } else if (purchaseDetails is AppStorePurchaseDetails) {
//         String transactionId = purchaseDetails.skPaymentTransaction
//             .originalTransaction?.transactionIdentifier ??
//             "";
//         return _transactionDeviceRepository
//             .registerByAppleTransactionId(transactionId)
//             .first;
//       } else {
//         Exception error = Exception("Unsupported purchase details!");
//         Log.exception(error);
//         return Result.error(error);
//       }
//     } on Exception catch (e) {
//       Log.exception(e);
//       return Result.error(e);
//     }
//   }
//
//   Future<Result<PurchaseDetails, Exception>>
//   _waitForPurchaseResultAsync() async {
//     try {
//       final List<PurchaseDetails> purchaseDetailsList =
//       await InAppPurchase.instance.purchaseStream.first;
//
//       final PurchaseDetails purchaseDetails = purchaseDetailsList.first;
//       switch (purchaseDetails.status) {
//         case PurchaseStatus.pending:
//           return Future.delayed(const Duration(milliseconds: 1000), () {
//             return _waitForPurchaseResultAsync();
//           });
//         case PurchaseStatus.purchased:
//           if (purchaseDetails.pendingCompletePurchase && Platform.isIOS) {
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//           }
//
//           return Result.success(purchaseDetails);
//         case PurchaseStatus.error:
//           if (purchaseDetails.pendingCompletePurchase && Platform.isIOS) {
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//           }
//
//           Exception error = Exception("Purchase error: ${purchaseDetails.error}");
//           Log.exception(error);
//           return Result.error(error);
//         case PurchaseStatus.restored:
//           if (purchaseDetails.pendingCompletePurchase && Platform.isIOS) {
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//           }
//
//           return Result.success(purchaseDetails);
//         case PurchaseStatus.canceled:
//           if (purchaseDetails.pendingCompletePurchase && Platform.isIOS) {
//             await InAppPurchase.instance.completePurchase(purchaseDetails);
//           }
//
//           Exception error = Exception("Purchase error: Canceled");
//           Log.exception(error);
//           return Result.error(error);
//       }
//     } on Exception catch (e) {
//       Log.exception(e);
//       return Result.error(e);
//     }
//   }
// }
