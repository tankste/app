import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/map_provider_repository.dart';
import 'package:settings/repository/permission_repository.dart';

class SettingsModuleFactory {
  static DeveloperSettingsRepository createDeveloperSettingsRepository() {
    return LocalDeveloperSettingsRepository();
  }

  static MapProviderRepository createMapProviderRepository() {
    return LocalMapProviderRepository();
  }

  static PermissionRepository createPermissionRepository() {
    return LocalPermissionRepository();
  }
}
