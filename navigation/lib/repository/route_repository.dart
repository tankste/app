import 'package:core/config/config_repository.dart';
import 'package:http/http.dart' as http;
import 'package:navigation/coordinate_model.dart';
import 'dart:convert';

import 'package:navigation/route_model.dart';

abstract class RouteRepository {
  Future<RouteModel> getRoutePreview(CoordinateModel from, CoordinateModel to);
}

class GoogleMapsRouteRepository extends RouteRepository {

  final ConfigRepository configRepository;

  GoogleMapsRouteRepository(this.configRepository);

  @override
  Future<RouteModel> getRoutePreview(
      CoordinateModel from, CoordinateModel to) async {
    final Uri url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?key=${await _getMapsKey()}&origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}");
    var response = await http.get(url);
    final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

    Map<String, dynamic> route = jsonResponse['routes'][0];
    Map<String, dynamic> leg = route['legs'][0];

    String encodedPoints = route["overview_polyline"]["points"];
    return RouteModel(leg['distance']['value'], leg['duration']['value'],
        decodePolyline(encodedPoints));
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
      CoordinateModel p =
          CoordinateModel(latitude: (lat / 1E5).toDouble(), longitude: (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Future<String> _getMapsKey() async {
    return configRepository.get().then((config) => config.googleMapsKey);
  }
}
