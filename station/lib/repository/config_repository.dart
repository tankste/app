import 'package:core/log/log.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:core/config/model/config_model.dart' as core;
import 'package:core/config/config_repository.dart' as core;

abstract class ConfigRepository {
  Stream<Result<ConfigModel, Exception>> get();
}

class LocalConfigRepository extends ConfigRepository {
  static final LocalConfigRepository _instance =
      LocalConfigRepository._internal();

  late core.ConfigRepository _coreConfigRepository;

  factory LocalConfigRepository(core.ConfigRepository coreConfigRepository) {
    _instance._coreConfigRepository = coreConfigRepository;
    return _instance;
  }

  LocalConfigRepository._internal();

  @override
  Stream<Result<ConfigModel, Exception>> get() {
    //TODO: cache stream
    return _getAsync().asStream();
  }

  Future<Result<ConfigModel, Exception>> _getAsync() async {
    try {
      core.ConfigModel coreConfig = await _coreConfigRepository.get();
      Map<String, dynamic> jsonStationConfig =
          coreConfig.jsonConfigFor("station");

      return Result.success(ConfigModel(
        apiBaseUrl: jsonStationConfig["apiBaseUrl"] ?? "",
      ));
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }
}
