import 'package:core/app/repository/app_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/developer/repository/developer_settings_repository.dart';
import 'package:settings/developer/usecase/enable_developer_mode_use_case.dart';
import 'package:settings/version/ui/cubit/version_item_state.dart';
import 'package:settings/version/usecase/get_app_version_use_case.dart';

class VersionItemCubit extends Cubit<VersionItemState> {
  final GetAppVersionUseCase _getAppVersionUseCase =
      GetAppVersionUseCaseImpl(LocalAppInfoRepository());

  final EnableDeveloperModeUseCase _enableDeveloperModeUseCase =
      EnableDeveloperModeUseCaseImpl(LocalDeveloperSettingsRepository());

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
      _enableDeveloperModeUseCase.invoke(true).then((value) {
        _clickCount = 0;
        emit(VersionItemState.success(state.version ?? "", true));
        return value;
      }).catchError((error) => emit(VersionItemState.failure(error)));
    }
  }
}
