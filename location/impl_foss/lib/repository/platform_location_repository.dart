import 'package:core/log/log.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_core/model/location_model.dart';
import 'package:location_core/model/permission_model.dart';
import 'package:location_core/repository/location_permission_repository.dart';
import 'package:location_core/repository/location_repository.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:navigation_core/model/coordinate_model.dart';

class PlatformLocationRepository extends LocationRepository {
  static final PlatformLocationRepository _instance =
      PlatformLocationRepository._internal();

  PlatformLocationRepository._internal();

  late LocationPermissionRepository _permissionRepository;

  factory PlatformLocationRepository(
      LocationPermissionRepository permissionRepository) {
    _instance._permissionRepository = permissionRepository;
    return _instance;
  }

  @override
  Future<LocationModel?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Log.i("Can not fetch location. Location service is disabled.");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Log.w("Unable to fetch location. Location permission denied.");
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      Log.w("Unable to fetch location. Location permission denied forever.");
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(forceLocationManager: true));
    return LocationModel(
        coordinate: CoordinateModel(
            latitude: position.latitude, longitude: position.longitude));
  }

  @override
  Future<LocationModel?> getLastKnownLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Log.w("Unable to fetch location. Location permission denied.");
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      Log.w("Unable to fetch location. Location permission denied forever.");
      return null;
    }

    Position? position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    if (position == null) {
      return null;
    }

    return LocationModel(
        coordinate: CoordinateModel(
            latitude: position.latitude, longitude: position.longitude));
  }

  @override
  double distanceBetween(CoordinateModel from, CoordinateModel to) {
    return Geolocator.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
  }

  @override
  Future<Result<bool, Exception>> requestPermission(bool force) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      return Result.success(true);
    } else if (permission == LocationPermission.deniedForever) {
      Log.i(
          "Can not request location permissions. Already in state denied forever.");
      return Result.success(false);
    }

    Result<PermissionModel, Exception> locationPermissionResult =
        await _permissionRepository.getLocationPermission();
    if (locationPermissionResult.isError()) {
      Exception error = locationPermissionResult.tryGetError()!;
      Log.exception(error);
      return Result.error(error);
    }

    PermissionModel locationPermission =
        locationPermissionResult.tryGetSuccess()!;

    // Ask for permission only once, or if the user request by locate me button
    if (!force && locationPermission.hasRequested) {
      Log.i("Location permission already request, skip a second time request.");
      return Result.success(false);
    }

    permission = await Geolocator.requestPermission();
    _permissionRepository.updateLocationPermission(
        locationPermission.copyWith(hasRequested: true));

    if (permission == LocationPermission.denied) {
      Log.i("Location permission denied.");
      return Result.success(false);
    } else if (permission == LocationPermission.deniedForever) {
      Log.i("Location permission denied forever.");
      return Result.success(false);
    }

    return Result.success(true);
  }
}
