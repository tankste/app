import 'package:core/app/model/app_info_model.dart';
import 'package:core/app/repository/app_info_repository.dart';
import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';

abstract class UpdateMapProviderUseCase {
  Future<DeveloperSettingsModel> invoke(
      DeveloperSettingsMapProvider mapProvider);
}

class UpdateMapProviderUseCaseImpl extends UpdateMapProviderUseCase {
  final DeveloperSettingsRepository _developerSettingsRepository;

  UpdateMapProviderUseCaseImpl(this._developerSettingsRepository);

  @override
  Future<DeveloperSettingsModel> invoke(
      DeveloperSettingsMapProvider mapProvider) {
    return _developerSettingsRepository.get().first.then((developerSettings) {
      return _developerSettingsRepository.update(DeveloperSettingsModel(
          developerSettings.isDeveloperModeEnabled,
          developerSettings.isFetchingWithoutLocationEnabled,
          developerSettings.isPercentagePriceRangesEnabled,
          mapProvider));
    });
  }
}
