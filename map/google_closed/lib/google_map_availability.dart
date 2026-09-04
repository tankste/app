import 'dart:io';

import 'package:core/config/config_repository.dart';
import 'package:map_core/map_availability.dart';

class GoogleMapAvailability extends MapAvailability {
  final ConfigRepository _configRepository;

  GoogleMapAvailability(this._configRepository);

  @override
  bool isAvailable() {
    return true;
  }

  @override
  Future<bool> isDefault() {
    if (!Platform.isAndroid) {
      return Future.value(false);
    }

    return _configRepository
        .getBoolValue("maplibre_as_default")
        .first
        .then((useMapLibreMap) => !useMapLibreMap)
        .catchError((error) => false);
  }
}
