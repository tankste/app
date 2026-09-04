import 'package:sponsor_core/repository/membership_repository.dart';
import 'package:sponsor_core/repository/product_repository.dart';
import 'package:sponsor_core/repository/provider_repository.dart';
import 'package:sponsor_data/repository/store_membership_repository.dart';
import 'package:sponsor_data/repository/store_product_repository.dart';
import 'package:sponsor_data/repository/store_provider_repository.dart';

class SponsorDataModuleFactory {
  static MembershipRepository createMembershipRepository() {
    return StoreMembershipRepository();
  }

  static ProductRepository createProductRepository() {
    return StoreProductRepository();
  }

  static ProviderRepository createProviderRepository() {
    return StoreProviderRepository();
  }
}
