import 'dart:convert';
import 'package:core/config/config_repository.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/dto/station_dto.dart';

abstract class StationRepository {
  Stream<Result<StationModel, Exception>> get(int id);
}

class TanksteWebStationRepository extends StationRepository {
  static final TanksteWebStationRepository _instance =
      TanksteWebStationRepository._internal();

  factory TanksteWebStationRepository() {
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
      Uri url = Uri.parse('http://10.0.2.2:4000/stations/$id');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        StationDto stationDto = StationDto.fromJson(jsonResponse);
        StationModel station = stationDto.toModel();

        return Result.success(station);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
