import 'package:core/app/repository/app_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/ui/version/cubit/version_item_state.dart';
import 'package:settings/usecase/get_app_version_use_case.dart';

class VersionItemCubit extends Cubit<VersionItemState> {
  final GetAppVersionUseCase _getAppVersionUseCase =
      GetAppVersionUseCaseImpl(LocalAppInfoRepository());

  final DeveloperSettingsRepository _developerSettingsRepository =
      SettingsModuleFactory.createDeveloperSettingsRepository();

  int _clickCount = 0;

  VersionItemCubit() : super(VersionItemState.loading()) {
    _fetchVersion();
  }

  void _fetchVersion() {
    _getAppVersionUseCase
        .invoke()
        .then((version) => emit(VersionItemState.success(version, false)))
        .catchError((error) => emit(VersionItemState.failure(error)));
  }

  void onClicked() {
    if (++_clickCount >= 5) {
      _developerSettingsRepository.get()
        .first
        .then((developerSettings) {
          return _developerSettingsRepository.update(developerSettings.copyWith(isDeveloperModeEnabled: true));
        })
        .then((_) {
          _clickCount = 0;
          emit(VersionItemState.success(state.version ?? "", true));
        });
    }
  }
}
