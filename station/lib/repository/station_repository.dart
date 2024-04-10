import 'dart:convert';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/currency_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/config_repository.dart';
import 'package:station/repository/currency_repository.dart';
import 'package:station/repository/dto/station_dto.dart';

abstract class StationRepository {
  Stream<Result<StationModel, Exception>> get(int id);
}

class TanksteWebStationRepository extends StationRepository {
  static final TanksteWebStationRepository _instance =
      TanksteWebStationRepository._internal();

  late CurrencyRepository _currencyRepository;
  late ConfigRepository _configRepository;

  factory TanksteWebStationRepository(CurrencyRepository currencyRepository,
      ConfigRepository configRepository) {
    _instance._currencyRepository = currencyRepository;
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebStationRepository._internal();

  @override
  Stream<Result<StationModel, Exception>> get(int id) {
    //TODO: cache stream
    return _getAsync(id).asStream();
  }

  Future<Result<StationModel, Exception>> _getAsync(int id) async {
    try {
      List<CurrencyModel> currencies =
          (await _currencyRepository.list().first).tryGetSuccess()!;

      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/stations/$id');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        StationDto stationDto = StationDto.fromJson(jsonResponse);
        StationModel station = stationDto.toModel(currencies);

        return Result.success(station);
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
