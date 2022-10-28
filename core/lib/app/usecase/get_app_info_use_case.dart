import 'package:core/app/model/app_info_model.dart';
import 'package:core/app/repository/app_info_repository.dart';

abstract class GetAppInfoUseCase {
  Future<AppInfoModel> invoke();
}

class GetAppInfoUseCaseImpl extends GetAppInfoUseCase {
  final AppInfoRepository _appInfoRepository;

  GetAppInfoUseCaseImpl(this._appInfoRepository);

  @override
  Future<AppInfoModel> invoke() {
    return _appInfoRepository.get();
  }
}
