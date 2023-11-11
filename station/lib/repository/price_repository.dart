import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:station/model/price_model.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/dto/price_dto.dart';
import 'package:station/repository/dto/station_dto.dart';

abstract class PriceRepository {
  Stream<Result<PriceModel, Exception>> get(int id);
}

class TanksteWebPriceRepository extends PriceRepository {
  static final TanksteWebPriceRepository _instance =
      TanksteWebPriceRepository._internal();

  factory TanksteWebPriceRepository() {
    return _instance;
  }

  TanksteWebPriceRepository._internal();

  @override
  Stream<Result<PriceModel, Exception>> get(int stationId) {
    //TODO: cache stream
    return _getAsync(stationId).asStream();
  }

  Future<Result<PriceModel, Exception>> _getAsync(int stationId) async {
    try {
      Uri url = Uri.parse('http://10.0.2.2:4000/stations/$stationId/price');
      http.Response response = await http
          .get(url); //TODO: add `, headers: await _apiRepository.getHeaders()`
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        PriceDto priceDto = PriceDto.fromJson(jsonResponse);
        PriceModel price = priceDto.toModel();

        return Result.success(price);
      } else {
        return Result.error(Exception("API Error!\n\n${response.body}"));
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
