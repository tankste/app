import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/price_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/config_repository.dart';
import 'package:station/repository/dto/price_dto.dart';
import 'package:station/repository/dto/station_dto.dart';

abstract class PriceRepository {
  Stream<Result<List<PriceModel>, Exception>> list(int stationId);
}

class TanksteWebPriceRepository extends PriceRepository {
  static final TanksteWebPriceRepository _instance =
      TanksteWebPriceRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebPriceRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebPriceRepository._internal();

  @override
  Stream<Result<List<PriceModel>, Exception>> list(int stationId) {
    //TODO: cache stream
    return _listAsync(stationId).asStream();
  }

  Future<Result<List<PriceModel>, Exception>> _listAsync(int stationId) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      Uri url = Uri.parse('${config.apiBaseUrl}/stations/$stationId/prices');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<PriceModel> prices = jsonResponse
            .map((e) => PriceDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(prices);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
