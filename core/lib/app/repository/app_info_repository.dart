import 'package:core/app/model/app_info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoRepository {
  Future<AppInfoModel> get();
}

class LocalAppInfoRepository extends AppInfoRepository {
  @override
  Future<AppInfoModel> get() async {
    return PackageInfo.fromPlatform().then((packageInfo) => AppInfoModel(
          packageInfo.appName,
          packageInfo.version,
          packageInfo.buildNumber,
          packageInfo.packageName,
          packageInfo.installerStore,
        ));
  }
}
