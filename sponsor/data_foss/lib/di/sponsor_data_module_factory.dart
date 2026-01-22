import 'package:sponsor_core/repository/membership_repository.dart';
import 'package:sponsor_core/repository/product_repository.dart';
import 'package:sponsor_core/repository/provider_repository.dart';
import 'package:sponsor_data/repository/foss_membership_repository.dart';
import 'package:sponsor_data/repository/foss_product_repository.dart';
import 'package:sponsor_data/repository/foss_provider_repository.dart';

class SponsorDataModuleFactory {
  static MembershipRepository createMembershipRepository() {
    return FossMembershipRepository();
  }

  static ProductRepository createProductRepository() {
    return FossProductRepository();
  }

  static ProviderRepository createProviderRepository() {
    return FossProviderRepository();
  }
}
