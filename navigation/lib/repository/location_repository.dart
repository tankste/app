import 'package:geolocator/geolocator.dart';
import 'package:navigation/coordinate_model.dart';

abstract class LocationRepository {
  Future<CoordinateModel?> getCurrentLocation();
}

class GpsLocationRepository extends LocationRepository {
  @override
  Future<CoordinateModel?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition();
    return CoordinateModel(
        latitude: position.latitude, longitude: position.longitude);
  }
}
