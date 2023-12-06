import 'package:core/di/core_module_factory.dart';
import 'package:sponsor/repository/balance_repository.dart';
import 'package:sponsor/repository/comment_repository.dart';
import 'package:sponsor/repository/config_repository.dart';
import 'package:sponsor/repository/product_repository.dart';
import 'package:sponsor/repository/purchase_repository.dart';

class SponsorModuleFactory {
  static BalanceRepository createBalanceRepository() {
    return TanksteWebBalanceRepository(createConfigRepository());
  }

  static ProductRepository createProductRepository() {
    return MobileProductRepository(
        createPurchaseRepository(),
        CoreModuleFactory.createDeviceRepository(),
        createBalanceRepository(),
        createCommentRepository());
  }

  static PurchaseRepository createPurchaseRepository() {
    return TanksteWebPurchaseRepository(
        createConfigRepository(), CoreModuleFactory.createDeviceRepository());
  }

  static CommentRepository createCommentRepository() {
    return TanksteWebCommentRepository(
        CoreModuleFactory.createDeviceRepository(), createConfigRepository());
  }

  static ConfigRepository createConfigRepository() {
    return LocalConfigRepository(CoreModuleFactory.createConfigRepository());
  }
}
