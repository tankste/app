import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';

abstract class UpdateFetchWithoutLocationUseCase {
  Future<DeveloperSettingsModel> invoke(bool isFetchWithoutLocationEnabled);
}

class UpdateFetchWithoutLocationUseCaseImpl
    extends UpdateFetchWithoutLocationUseCase {
  final DeveloperSettingsRepository _developerSettingsRepository;

  UpdateFetchWithoutLocationUseCaseImpl(this._developerSettingsRepository);

  @override
  Future<DeveloperSettingsModel> invoke(bool isFetchWithoutLocationEnabled) {
    return _developerSettingsRepository.get().first.then((developerSettings) {
      return _developerSettingsRepository.update(DeveloperSettingsModel(
          developerSettings.isDeveloperModeEnabled,
          isFetchWithoutLocationEnabled,
          developerSettings.isPercentagePriceRangesEnabled,
          developerSettings.mapProvider));
    });
  }
}
