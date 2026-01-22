import 'dart:io';

import 'package:core/config/config_repository.dart';
import 'package:map_core/map_availability.dart';

class MapLibreMapAvailability extends MapAvailability {
  final ConfigRepository _configRepository;

  MapLibreMapAvailability(this._configRepository);

  @override
  bool isAvailable() {
    return true;
  }

  @override
  Future<bool> isDefault() {
    return _configRepository
        .get()
        .then((config) => config.useMapLibreMap)
        .catchError((error) => true);
  }
}
