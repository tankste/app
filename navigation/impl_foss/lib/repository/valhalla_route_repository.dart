import 'dart:convert';
import 'dart:core';

import 'package:core/config/config_repository.dart';
import 'package:core/log/log.dart';
import 'package:http/http.dart' as http;
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/model/route_model.dart';
import 'package:navigation_core/repository/route_repository.dart';

class ValhallaRouteRepository extends RouteRepository {
  final ConfigRepository configRepository;

  ValhallaRouteRepository(this.configRepository);

  @override
  Future<Result<RouteModel, Exception>> getRoutePreview(
    CoordinateModel from,
    CoordinateModel to,
  ) async {
    try {
      Uri url = Uri.parse('${await _getRouteApiUrl()}/route');

      Map<String, dynamic> body = {
        'locations': [
          {'lat': from.latitude, 'lon': from.longitude, 'type': "break"},
          {'lat': to.latitude, 'lon': to.longitude, 'type': "break"},
        ],
        'costing': "auto",
        'units': "kilometers",
        'directions_type': "none",
      };

      http.Response response = await http.post(url, body: jsonEncode(body));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        Map<String, dynamic> jsonResponse =
            json.decode(response.body) as Map<String, dynamic>;

        Map<String, dynamic> leg = jsonResponse["trip"]["legs"][0];
        json.decode(response.body) as Map<String, dynamic>;
        return Result.success(
          RouteModel(
            distanceMeters: (leg['summary']['length'] * 1000).toInt(),
            travelTimeSeconds: leg['summary']['time'].toInt(),
            routeCoordinates: decodePolyline(leg["shape"]),
          ),
        );
      } else {
        Exception error = Exception("API Error!\n\n${response.body}");
        Log.exception(error);
        return Result.error(error);
      }
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }

    return Future.value(
      Result.error(Exception("Route is currently not supported.")),
    );
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
        latitude: (lat / 1E6).toDouble(),
        longitude: (lng / 1E6).toDouble(),
      );
      poly.add(p);
    }
    return poly;
  }

  Future<String> _getRouteApiUrl() async {
    return configRepository.get().then((config) => config.routeApiUrl);
  }
}
