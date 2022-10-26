
import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';

abstract class GetDeveloperSettingsUseCase {
  Stream<DeveloperSettingsModel> invoke();
}

class GetDeveloperSettingsUseCaseImpl extends GetDeveloperSettingsUseCase {
  final DeveloperSettingsRepository _developerSettingsRepository;

  GetDeveloperSettingsUseCaseImpl(this._developerSettingsRepository);

  @override
  Stream<DeveloperSettingsModel> invoke() {
    return _developerSettingsRepository.get();
  }
}
