import 'package:core/config/config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/streams.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/configuration/ui/item/configuration_item_state.dart';

class ConfigurationItemCubit extends Cubit<ConfigurationItemState> {
  final DeveloperSettingsRepository _developerSettingsRepository =
      SettingsModuleFactory.createDeveloperSettingsRepository();
  final ConfigRepository _configRepository =
      SettingsModuleFactory.createConfigRepository();

  ConfigurationItemCubit() : super(LoadingConfigurationItemState()) {
    _fetch();
  }

  void _fetch() {
    CombineLatestStream.combine2(
      _configRepository.getBoolValue("configuration_public"),
      _developerSettingsRepository.get().map(
        (developerSettings) =>
            developerSettings.enabledFeatures.contains(Feature.configuration),
      ),
      (configurationPublic, featureEnabled) {
        if (configurationPublic || featureEnabled) {
          return AvailableConfigurationItemState();
        } else {
          return UnavailableConfigurationItemState();
        }
      },
    ).listen((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }
}
