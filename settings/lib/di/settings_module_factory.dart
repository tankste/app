import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/log_repository.dart';
import 'package:settings/repository/permission_repository.dart';

class SettingsModuleFactory {
  static DeveloperSettingsRepository createDeveloperSettingsRepository() {
    return LocalDeveloperSettingsRepository();
  }

  static PermissionRepository createPermissionRepository() {
    return LocalPermissionRepository();
  }

  static LogRepository createLogRepository() {
    return LocalLogRepository();
  }
}
