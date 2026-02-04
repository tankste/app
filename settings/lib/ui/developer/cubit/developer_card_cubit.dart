import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:map/di/map_module_factory.dart';
import 'package:map/repository/camera_position_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/developer/cubit/developer_card_state.dart';

class DeveloperCardCubit extends Cubit<DeveloperCardState> {
  final DeveloperSettingsRepository _developerSettingsRepository =
      LocalDeveloperSettingsRepository();

  final LocationPermissionRepository _locationPermissionRepository =
      LocationModuleFactory.createLocationPermissionRepository();

  final CameraPositionRepository _cameraPositionRepository =
      MapModuleFactory.createCameraPositionRepository();

  DeveloperSettingsModel? _developerSettings;

  DeveloperCardCubit() : super(LoadingDeveloperCardState()) {
    _fetchDeveloperSettings();
  }

  void _fetchDeveloperSettings() {
    emit(LoadingDeveloperCardState());

    _developerSettingsRepository.get().listen((developerSettings) {
      if (isClosed) {
        return;
      }

      _developerSettings = developerSettings;

      emit(developerSettings.isDeveloperModeEnabled
          ? EnabledDeveloperCardState()
          : DisabledDeveloperCardState());
    }).onError((error) => emit(ErrorDeveloperCardState(errorDetails: error)));
  }

  void onDeveloperModeChanged(bool isEnabled) {
    DeveloperSettingsModel? developerSettings = _developerSettings;
    if (developerSettings == null) {
      return;
    }

    _developerSettingsRepository
        .update(developerSettings.copyWith(isDeveloperModeEnabled: isEnabled));
  }

  void onResetCacheClicked() {
    CombineLatestStream.combine2(
        _locationPermissionRepository.deleteLocationPermission().asStream(),
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
