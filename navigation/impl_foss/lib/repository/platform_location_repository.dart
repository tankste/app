import 'package:geolocator/geolocator.dart';
import 'package:navigation_core/model/coordinate_model.dart';
import 'package:navigation_core/repository/location_repository.dart';

class PlatformLocationRepository extends LocationRepository {
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
