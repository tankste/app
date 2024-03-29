import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:station/model/config_model.dart';
import 'package:station/model/marker_model.dart';
import 'package:http/http.dart' as http;
import 'package:station/repository/config_repository.dart';
import 'package:station/repository/dto/marker_dto.dart';

abstract class MarkerRepository {
  Stream<Result<List<MarkerModel>, Exception>> list(
      List<CoordinateModel> coordinates);
}

class TanksteWebMarkerRepository extends MarkerRepository {
  static final TanksteWebMarkerRepository _instance =
      TanksteWebMarkerRepository._internal();

  late ConfigRepository _configRepository;

  factory TanksteWebMarkerRepository(ConfigRepository configRepository) {
    _instance._configRepository = configRepository;
    return _instance;
  }

  TanksteWebMarkerRepository._internal();

  @override
  Stream<Result<List<MarkerModel>, Exception>> list(
      List<CoordinateModel> coordinates) {
    //TODO: cache stream
    //TODO: re-fetch after delayed time, to show the newest prices
    return _listAsync(coordinates).asStream();
  }

  Future<Result<List<MarkerModel>, Exception>> _listAsync(
      List<CoordinateModel> coordinates) async {
    try {
      Result<ConfigModel, Exception> configResult =
          await _configRepository.get().first;
      if (configResult.isError()) {
        return Result.error(configResult.tryGetError()!);
      }
      ConfigModel config = configResult.tryGetSuccess()!;

      String boundQuery = coordinates
          .map((c) => "boundary[]=${c.latitude},${c.longitude}")
          .join("&");

      Uri url = Uri.parse('${config.apiBaseUrl}/markers?$boundQuery');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<MarkerModel> markers = jsonResponse
            .map((e) => MarkerDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        return Result.success(markers);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
