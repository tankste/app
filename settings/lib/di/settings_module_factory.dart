import 'package:settings/repository/map_provider_repository.dart';

class SettingsModuleFactory {
  static MapProviderRepository createMapProviderRepository() {
    return LocalMapProviderRepository();
  }
}
