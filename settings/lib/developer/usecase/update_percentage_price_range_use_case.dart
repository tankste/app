import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';

abstract class UpdatePercentagePriceRangeUseCase {
  Future<DeveloperSettingsModel> invoke(bool isPercentagePriceRangeEnabled);
}

class UpdatePercentagePriceRangeUseCaseImpl
    extends UpdatePercentagePriceRangeUseCase {
  final DeveloperSettingsRepository _developerSettingsRepository;

  UpdatePercentagePriceRangeUseCaseImpl(this._developerSettingsRepository);

  @override
  Future<DeveloperSettingsModel> invoke(bool isPercentagePriceRangeEnabled) {
    return _developerSettingsRepository.get().first.then((developerSettings) {
      return _developerSettingsRepository.update(DeveloperSettingsModel(
          developerSettings.isDeveloperModeEnabled,
          developerSettings.isFetchingWithoutLocationEnabled,
          isPercentagePriceRangeEnabled,
          developerSettings.mapProvider));
    });
  }
}
