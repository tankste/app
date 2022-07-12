import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:station/station_model.dart';

abstract class StationRepository {
  Future<StationModel> get(String id);
}

class TankerkoenigStationRepository extends StationRepository {
  @override
  Future<StationModel> get(String id) async {
    var url = Uri.parse(
        'https://creativecommons.tankerkoenig.de/json/detail.php?id=$id&apikey=***REMOVED***');
    var response = await http.get(url);
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    return StationModel.fromJson(jsonResponse['station']);
  }
}
