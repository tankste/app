import 'package:core/app/repository/app_info_repository.dart';

abstract class GetAppVersionUseCase {
  Future<String> invoke();
}

class GetAppVersionUseCaseImpl extends GetAppVersionUseCase {
  final AppInfoRepository _appInfoRepository;

  GetAppVersionUseCaseImpl(this._appInfoRepository);

  @override
  Future<String> invoke() {
    return _appInfoRepository.get()
      .then((info) => info.nameVersionIdentifier());
  }
}
