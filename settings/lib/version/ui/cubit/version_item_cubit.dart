import 'package:core/app/repository/app_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings/version/ui/cubit/version_item_state.dart';
import 'package:settings/version/usecase/get_app_version_use_case.dart';

class VersionItemCubit extends Cubit<VersionItemState> {
  final GetAppVersionUseCase getAppVersionUseCase =
      GetAppVersionUseCaseImpl(LocalAppInfoRepository());

  VersionItemCubit() : super(VersionItemState.loading()) {
    _fetchVersion();
  }

  void _fetchVersion() {
    getAppVersionUseCase
        .invoke()
        .then((version) => emit(VersionItemState.success(version, false)))
        .catchError((error) => emit(VersionItemState.failure(error)));
  }
}
