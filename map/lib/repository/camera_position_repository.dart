import 'dart:async';

import 'package:map/model/camera_position_model.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CameraPositionRepository {
  Stream<Result<CameraPositionModel?, Exception>> getLast();

  Stream<Result<CameraPositionModel, Exception>> updateLast(
      CameraPositionModel cameraPosition);

  Stream<Result<void, Exception>> deleteLast();
}

class LocalCameraPositionRepository extends CameraPositionRepository {
  static final LocalCameraPositionRepository _singleton =
      LocalCameraPositionRepository._internal();

  factory LocalCameraPositionRepository() {
    return _singleton;
  }

  LocalCameraPositionRepository._internal();

  final StreamController<Result<CameraPositionModel?, Exception>>
      _getLastController = StreamController.broadcast();

  @override
  Stream<Result<CameraPositionModel?, Exception>> getLast() {
    _getLastAsync().then((result) => _getLastController.add(result));

    return _getLastController.stream;
  }

  Future<Result<CameraPositionModel?, Exception>> _getLastAsync() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      double? latitude = preferences.getDouble('camera_position_last_latitude');
      double? longitude =
          preferences.getDouble('camera_position_last_longitude');
      double? zoom = preferences.getDouble('camera_position_last_zoom');

      if (latitude == null || longitude == null || zoom == null) {
        return Result.success(null);
      }

      CameraPositionModel cameraPosition = CameraPositionModel(
          latitude: latitude, longitude: longitude, zoom: zoom);
      return Result.success(cameraPosition);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<CameraPositionModel, Exception>> updateLast(
      CameraPositionModel cameraPosition) {
    StreamController<Result<CameraPositionModel, Exception>> controller =
        StreamController.broadcast();

    _updateLastAsync(cameraPosition)
        .then((result) => controller.add(result))
        .then((_) => getLast());

    return controller.stream;
  }

  Future<Result<CameraPositionModel, Exception>> _updateLastAsync(
      CameraPositionModel cameraPosition) async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.setDouble(
          'camera_position_last_latitude', cameraPosition.latitude);
      await preferences.setDouble(
          'camera_position_last_longitude', cameraPosition.longitude);
      await preferences.setDouble(
          'camera_position_last_zoom', cameraPosition.zoom);
      return Result.success(cameraPosition);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<void, Exception>> deleteLast() {
    StreamController<Result<void, Exception>> controller =
        StreamController.broadcast();

    _deleteLastAsync()
        .then((result) => controller.add(result))
        .then((_) => getLast());

    return controller.stream;
  }

  Future<Result<void, Exception>> _deleteLastAsync() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.remove('camera_position_last_latitude');
      await preferences.remove('camera_position_last_longitude');
      await preferences.remove('camera_position_last_zoom');
      return Result.success(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
