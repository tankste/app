import 'dart:convert';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/open_time.dart';
import 'package:station/repository/config_repository.dart';
import 'package:station/repository/dto/open_time_dto.dart';

abstract class OpenTimeRepository {
  Stream<Result<List<OpenTimeModel>, Exception>> list(int stationId);
}

class TanksteWebOpenTimeRepository extends OpenTimeRepository {
  static final TanksteWebOpenTimeRepository _instance =
      TanksteWebOpenTimeRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebOpenTimeRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebOpenTimeRepository._internal();

  @override
  Stream<Result<List<OpenTimeModel>, Exception>> list(int stationId) {
    //TODO: cache stream
    return _listAsync(stationId).asStream();
  }

  Future<Result<List<OpenTimeModel>, Exception>> _listAsync(
      int stationId) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url =
          Uri.parse('${config.apiBaseUrl}/stations/$stationId/open-times');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<OpenTimeModel> openTimes = jsonResponse
            .map((e) => OpenTimeDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(openTimes);
      } else {
        Exception error = Exception("API Error!\n\n${response.body}");
        Log.exception(error);
        return Result.error(error);
      }
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }
}
