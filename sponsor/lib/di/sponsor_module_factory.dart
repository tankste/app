
import 'package:core/di/core_module_factory.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/product_repository.dart';
import 'package:sponsor/repository/purchase_repository.dart';

class SponsorModuleFactory {

  static BalanceRepository createBalanceRepository() {
    return TanksteWebBalanceRepository(createConfigRepository());
  }

  static ProductRepository createProductRepository() {
    return MobileProductRepository(createPurchaseRepository());
  }

  static PurchaseRepository createPurchaseRepository() {
    return TanksteWebPurchaseRepository(createConfigRepository());
  }

  static ConfigRepository createConfigRepository() {
    return LocalConfigRepository(CoreModuleFactory.createConfigRepository());
  }
}