import 'package:map_core/map_availability.dart';

class GoogleMapAvailability extends MapAvailability {

  @override
  bool isAvailable() {
    return false;
  }

  @override
  Future<bool> isDefault() {
    return Future.value(false);
  }
}