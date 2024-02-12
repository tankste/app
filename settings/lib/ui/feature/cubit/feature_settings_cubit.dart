import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/feature/cubit/feature_settings_state.dart';

class FeatureSettingsCubit extends Cubit<FeatureSettingsState> {
  final DeveloperSettingsRepository _developerSettingsRepository =
      SettingsModuleFactory.createDeveloperSettingsRepository();

  DeveloperSettingsModel? _developerSettings;

  FeatureSettingsCubit() : super(LoadingFeatureSettingsState()) {
    loadSettings();
  }

  void loadSettings() async {
    _developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      _developerSettings = developerSettings;

      emit(FeaturesFeatureSettingsState(
          availableFeatures: Feature.values,
          enabledFeatures: developerSettings.enabledFeatures));
    });
  }

  void onFeatureEnableChanged(Feature feature, bool isEnabled) {
    DeveloperSettingsModel? developerSettings = _developerSettings;
    if (developerSettings == null) {
      return;
    }

    List<Feature> updatedFeatures = developerSettings.enabledFeatures;
    if (isEnabled) {
      updatedFeatures.add(feature);
    } else {
      updatedFeatures.remove(feature);
    }

    _developerSettingsRepository
        .update(developerSettings.copyWith(enabledFeatures: updatedFeatures));
  }
}
