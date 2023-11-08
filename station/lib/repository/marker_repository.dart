import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';
import 'package:navigation/coordinate_model.dart';
import 'package:station/model/marker_model.dart';
import 'package:http/http.dart' as http;
import 'package:station/repository/dto/marker_dto.dart';

abstract class MarkerRepository {
  Stream<Result<List<MarkerModel>, Exception>> list(
      CoordinateModel position, int radius);
}

class TanksteWebMarkerRepository extends MarkerRepository {
  static final TanksteWebMarkerRepository _instance =
      TanksteWebMarkerRepository._internal();

  factory TanksteWebMarkerRepository() {
    return _instance;
  }

  TanksteWebMarkerRepository._internal();

  @override
  Stream<Result<List<MarkerModel>, Exception>> list(
      CoordinateModel position, int radius) {
    //TODO: cache stream
    //TODO: re-fetch after delayed time, to show the newest prices
    return _listAsync(position, radius).asStream();
  }

  Future<Result<List<MarkerModel>, Exception>> _listAsync(
      CoordinateModel position, int radius) async {
    try {
      Uri url = Uri.parse(
          'http://10.0.2.2:4000/markers?latitude=${position.latitude}&longitude=${position.longitude}&radius=$radius');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> jsonResponse =
            json.decode(response.body) as List<dynamic>;

        List<MarkerModel> markers = jsonResponse
            .map((e) => MarkerDto.fromJson(e))
            .map((dto) => dto.toModel())
            .toList();

        print("markers: $markers");
        return Result.success(markers);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
