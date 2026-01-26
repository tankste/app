import 'dart:convert';

import 'package:core/config/config_repository.dart';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/model/route_model.dart';
import 'package:navigation_core/repository/route_repository.dart';

class GoogleRouteRepository extends RouteRepository {
  final ConfigRepository configRepository;

  GoogleRouteRepository(this.configRepository);

  @override
  Future<Result<RouteModel, Exception>> getRoutePreview(
      CoordinateModel from, CoordinateModel to) async {
    try {
      final Uri url = Uri.parse(
          "https://maps.googleapis.com/maps/api/directions/json?key=${await _getMapsKey()}&origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}");
      var response = await http.get(url);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      List<dynamic> routes = jsonResponse['routes'];
      if (routes.isEmpty) {
        return Result.error(Exception("No route found."));
      }

      Map<String, dynamic> route = routes[0];
      List<dynamic> legs = route['legs'];
      if (legs.isEmpty) {
        return Result.error(Exception("No route found."));
      }

      Map<String, dynamic> leg = legs[0];

      String encodedPoints = route["overview_polyline"]["points"];
      return Result.success(RouteModel(leg['distance']['value'],
          leg['duration']['value'], decodePolyline(encodedPoints)));
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  /// Decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  List<CoordinateModel> decodePolyline(String encoded) {
    List<CoordinateModel> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      CoordinateModel p = CoordinateModel(
          latitude: (lat / 1E5).toDouble(), longitude: (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Future<String> _getMapsKey() async {
    return configRepository.get().then((config) => config.googleMapsKey);
  }
}
