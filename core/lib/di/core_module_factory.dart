import 'package:core/config/config_repository.dart';
import 'package:core/device/repository/device_repository.dart';

class CoreModuleFactory {
  static DeviceRepository createDeviceRepository() {
    return LocalDeviceRepository();
  }

  static ConfigRepository createConfigRepository() {
    return FileConfigRepository();
  }
}
