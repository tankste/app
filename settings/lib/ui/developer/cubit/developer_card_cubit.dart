import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/developer/cubit/developer_card_state.dart';
import 'package:settings/usecase/enable_developer_mode_use_case.dart';

class DeveloperCardCubit extends Cubit<DeveloperCardState> {
  final DeveloperSettingsRepository developerSettingsRepository =
      LocalDeveloperSettingsRepository();

  final EnableDeveloperModeUseCase enableDeveloperModeUseCase =
      EnableDeveloperModeUseCaseImpl(LocalDeveloperSettingsRepository());

  DeveloperCardCubit() : super(DeveloperCardState.loading()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(DeveloperCardState.loading());

    developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      emit(
          DeveloperCardState.success(developerSettings.isDeveloperModeEnabled));
    }).onError((error) => emit(DeveloperCardState.failure(error)));
  }

  void onDeveloperModeChanged(bool isEnabled) {
    enableDeveloperModeUseCase.invoke(isEnabled);
  }
}
