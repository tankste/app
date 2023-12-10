import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';

abstract class EnableDeveloperModeUseCase {
  Future<DeveloperSettingsModel> invoke(bool isEnabled);
}

class EnableDeveloperModeUseCaseImpl extends EnableDeveloperModeUseCase {
  final DeveloperSettingsRepository _developerSettingsRepository;

  EnableDeveloperModeUseCaseImpl(this._developerSettingsRepository);

  @override
  Future<DeveloperSettingsModel> invoke(bool isEnabled) {
    return _developerSettingsRepository
        .update(DeveloperSettingsModel(isEnabled));
  }
}
