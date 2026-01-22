import 'package:map_core/map_availability.dart';
import 'package:core/config/config_repository.dart';

class GoogleMapAvailability extends MapAvailability {
  final ConfigRepository _configRepository;

  GoogleMapAvailability(this._configRepository);

  @override
  bool isAvailable() {
    return true;
  }

  @override
  Future<bool> isDefault() {
    return _configRepository
        .get()
        .then((config) => !config.useMapLibreMap)
        .catchError((error) => false);
  }
}
