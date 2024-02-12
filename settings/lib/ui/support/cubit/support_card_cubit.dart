import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/support/cubit/support_card_state.dart';

class SupportCardCubit extends Cubit<SupportCardState> {
  final DeveloperSettingsRepository _developerSettingsRepository =
      SettingsModuleFactory.createDeveloperSettingsRepository();

  SupportCardCubit() : super(LoadingSupportCardState()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(LoadingSupportCardState());

    _developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      emit(developerSettings.isFeatureEnabled(Feature.logging)
          ? EnabledSupportCardState()
          : DisabledSupportCardState());
    });
  }
}
