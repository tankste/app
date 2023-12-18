import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/di/map_module_factory.dart';
import 'package:map/repository/camera_position_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/permission_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/permission_repository.dart';
import 'package:settings/ui/developer/cubit/developer_card_state.dart';
import 'package:settings/usecase/enable_developer_mode_use_case.dart';

class DeveloperCardCubit extends Cubit<DeveloperCardState> {
  final DeveloperSettingsRepository developerSettingsRepository =
      LocalDeveloperSettingsRepository();
  final PermissionRepository _permissionRepository =
      SettingsModuleFactory.createPermissionRepository();
  final CameraPositionRepository _cameraPositionRepository =
      MapModuleFactory.createCameraPositionRepository();

  final EnableDeveloperModeUseCase enableDeveloperModeUseCase =
      EnableDeveloperModeUseCaseImpl(LocalDeveloperSettingsRepository());

  DeveloperCardCubit() : super(LoadingDeveloperCardState()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(LoadingDeveloperCardState());

    developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      emit(developerSettings.isDeveloperModeEnabled
          ? EnabledDeveloperCardState()
          : DisabledDeveloperCardState());
    }).onError((error) => emit(ErrorDeveloperCardState(errorDetails: error)));
  }

  void onDeveloperModeChanged(bool isEnabled) {
    enableDeveloperModeUseCase.invoke(isEnabled);
  }

  void onResetCacheClicked() {
    CombineLatestStream.combine2(
        _permissionRepository.deleteLocationPermission(),
        _cameraPositionRepository.deleteLast(),
        (deletePermissionResult, deletePositionResult) {
      return deletePermissionResult.when((_) {
        return deletePositionResult.when((_) {
          return SuccessDeleteCacheEnabledDeveloperCardState();
        },
            (error) => ErrorDeleteCacheEnabledDeveloperCardState(
                errorDetails: error.toString()));
      },
          (error) => ErrorDeleteCacheEnabledDeveloperCardState(
              errorDetails: error.toString()));
    }).first.then((state) {
      if (isClosed) {
        return;
      }

      emit(state);
    });
  }
}
