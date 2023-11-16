import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/open_time.dart';
import 'package:station/repository/dto/open_time_dto.dart';

abstract class OpenTimeRepository {
  Stream<Result<List<OpenTimeModel>, Exception>> list(int stationId);
}

class TanksteWebOpenTimeRepository extends OpenTimeRepository {
  static final TanksteWebOpenTimeRepository _instance =
  TanksteWebOpenTimeRepository._internal();

  factory TanksteWebOpenTimeRepository() {
    return _instance;
  }

  TanksteWebOpenTimeRepository._internal();

  @override
  Stream<Result<List<OpenTimeModel>, Exception>> list(int stationId) {
    //TODO: cache stream
    return _listAsync(stationId).asStream();
  }

  Future<Result<List<OpenTimeModel>, Exception>> _listAsync(int stationId) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:4000/stations/$stationId/open-times');
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
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
