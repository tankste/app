import 'package:core/config/config_repository.dart';

class CoreModuleFactory {
  static ConfigRepository createConfigRepository() {
    return FileConfigRepository();
  }
}
