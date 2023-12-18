import 'package:core/di/core_module_factory.dart';
import 'package:map/repository/camera_position_repository.dart';
import 'package:map/usecase/get_map_provider_use_case.dart';
import 'package:settings/di/settings_module_factory.dart';

class MapModuleFactory {
  static GetMapProviderUseCase createGetMapProviderUseCase() {
    return DefaultGetMapProviderUseCase(
        SettingsModuleFactory.createMapProviderRepository(),
        CoreModuleFactory.createConfigRepository());
  }

  static CameraPositionRepository createCameraPositionRepository() {
    return LocalCameraPositionRepository();
  }
}
