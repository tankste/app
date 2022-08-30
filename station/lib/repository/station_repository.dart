import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navigation/coordinate_model.dart';
import 'package:station/station_model.dart';

abstract class StationRepository {
  //TODO: use enum instead of string for `type` parameter
  Future<List<StationModel>> list(
      String type, CoordinateModel position, int radius);

  Future<StationModel> get(String id);
}

class TankerkoenigStationRepository extends StationRepository {

  @override
  Future<List<StationModel>> list(
      String type, CoordinateModel position, int radius) async {
    var url = Uri.parse(
        'https://creativecommons.tankerkoenig.de/json/list.php?lat=${position.latitude}&lng=${position.longitude}&rad=$radius&sort=price&type=$type&apikey=***REMOVED***');
    var response = await http.get(url);
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    return (jsonResponse['stations'] as List)
        .map((i) => StationModel.fromJson(i, type))
        .toList();
  }

  @override
  Future<StationModel> get(String id) async {
    var url = Uri.parse(
        'https://creativecommons.tankerkoenig.de/json/detail.php?id=$id&apikey=***REMOVED***');
    var response = await http.get(url);
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    return StationModel.fromJson(jsonResponse['station'], null);
  }
}
