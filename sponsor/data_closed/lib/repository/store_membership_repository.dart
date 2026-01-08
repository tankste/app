import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sponsor_core/model/membership_model.dart';
import 'package:sponsor_core/repository/membership_repository.dart';

class StoreMembershipRepository extends MembershipRepository {
  static final StoreMembershipRepository _singleton =
      StoreMembershipRepository._internal();

  factory StoreMembershipRepository() {
    return _singleton;
  }

  StoreMembershipRepository._internal() {
    _inAppPurchase.restorePurchases();
  }

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  Stream<Result<MembershipModel?, Exception>> get() {
    return _inAppPurchase.isAvailable().asStream().flatMap((isAvailable) {
      if (isAvailable) {
        return _inAppPurchase.purchaseStream.map((purchases) {
          bool isMember = purchases.any((purchase) =>
              purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored);
          return Result.success(isMember ? MembershipModel() : null);
        });
      } else {
        return Stream.value(Result.error(Exception("Purchase unavailable")));
      }
    });
  }
}
