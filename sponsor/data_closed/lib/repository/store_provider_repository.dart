import 'package:sponsor_core/model/provider_model.dart';
import 'package:sponsor_core/repository/provider_repository.dart';

class StoreProviderRepository extends ProviderRepository {
  static final StoreProviderRepository _singleton =
      StoreProviderRepository._internal();

  factory StoreProviderRepository() {
    return _singleton;
  }

  StoreProviderRepository._internal();

  @override
  List<ProviderModel> list() {
    return [];
  }
}
