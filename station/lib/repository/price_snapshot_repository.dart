import 'dart:convert';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/fuel_type.dart';
import 'package:station/model/price_snapshot_model.dart';
import 'package:station/repository/config_repository.dart';

import 'dto/price_snapshot_dto.dart';

abstract class PriceSnapshotRepository {
  Future<Result<List<PriceSnapshotModel>, Exception>> list(int stationId, FuelType fuelType);
}

class TanksteWebPriceSnapshotRepository extends PriceSnapshotRepository {
  static final TanksteWebPriceSnapshotRepository _instance =
  TanksteWebPriceSnapshotRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebPriceSnapshotRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebPriceSnapshotRepository._internal();

  @override
  Future<Result<List<PriceSnapshotModel>, Exception>> list(int stationId, FuelType fuelType) {
    return _listAsync(stationId, fuelType);
  }

  Future<Result<List<PriceSnapshotModel>, Exception>> _listAsync(int stationId, FuelType fuelType) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        Exception error = configResult.tryGetError()!;
        Log.exception(error);
        return Result.error(error);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      String fuelTypeKey = PriceSnapshotDto.fuelTypeToJsonKey(fuelType);
      Uri url = Uri.parse('${config.apiBaseUrl}/stations/$stationId/price-snapshots?type=$fuelTypeKey');
      http.Response response = await http
          .get(url);
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<PriceSnapshotModel> priceSnapshots = jsonResponse
            .map((e) => PriceSnapshotDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(priceSnapshots);
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
