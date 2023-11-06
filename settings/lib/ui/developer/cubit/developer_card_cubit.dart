import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/developer/cubit/developer_card_state.dart';
import 'package:settings/usecase/enable_developer_mode_use_case.dart';
import 'package:settings/usecase/get_developer_settings_use_case.dart';
import 'package:settings/usecase/update_map_provider_use_case.dart';

class DeveloperCardCubit extends Cubit<DeveloperCardState> {
  final GetDeveloperSettingsUseCase getDeveloperSettingsUseCase =
      GetDeveloperSettingsUseCaseImpl(LocalDeveloperSettingsRepository());

  final EnableDeveloperModeUseCase enableDeveloperModeUseCase =
      EnableDeveloperModeUseCaseImpl(LocalDeveloperSettingsRepository());

  final UpdateMapProviderUseCase updateMapProviderUseCase =
      UpdateMapProviderUseCaseImpl(LocalDeveloperSettingsRepository());

  DeveloperCardCubit() : super(DeveloperCardState.loading()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(DeveloperCardState.loading());

    getDeveloperSettingsUseCase.invoke().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      emit(DeveloperCardState.success(developerSettings.isDeveloperModeEnabled,
          developerSettings.mapProvider));
    }).onError((error) => emit(DeveloperCardState.failure(error)));
  }

  void onDeveloperModeChanged(bool isEnabled) {
    enableDeveloperModeUseCase.invoke(isEnabled);
  }

  void onMapProviderChanged(DeveloperSettingsMapProvider mapProvider) {
    updateMapProviderUseCase.invoke(mapProvider);
  }
}
