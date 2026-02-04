import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/log_repository.dart';

class SettingsModuleFactory {
  static DeveloperSettingsRepository createDeveloperSettingsRepository() {
    return LocalDeveloperSettingsRepository();
  }

  static LogRepository createLogRepository() {
    return LocalLogRepository();
  }
}
