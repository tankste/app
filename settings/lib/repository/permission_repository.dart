import 'dart:async';

import 'package:multiple_result/multiple_result.dart';
import 'package:settings/model/permission_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PermissionRepository {
  Stream<Result<PermissionModel, Exception>> getLocationPermission();

  Stream<Result<PermissionModel, Exception>> updateLocationPermission(
      PermissionModel permission);

  Stream<Result<void, Exception>> deleteLocationPermission();
}

class LocalPermissionRepository extends PermissionRepository {
  static final LocalPermissionRepository _singleton =
      LocalPermissionRepository._internal();

  factory LocalPermissionRepository() {
    return _singleton;
  }

  LocalPermissionRepository._internal();

  StreamController<Result<PermissionModel, Exception>>
      _getLocationPermissionController = StreamController.broadcast();

  @override
  Stream<Result<PermissionModel, Exception>> getLocationPermission() {
    _getAsync().then((result) => _getLocationPermissionController.add(result));

    return _getLocationPermissionController.stream;
  }

  Future<Result<PermissionModel, Exception>> _getAsync() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      PermissionModel permission = PermissionModel(
          hasRequested:
              preferences.getBool('permission_location_requested') ?? false);
      return Result.success(permission);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<PermissionModel, Exception>> updateLocationPermission(
      PermissionModel permission) {
    StreamController<Result<PermissionModel, Exception>> controller =
        StreamController.broadcast();

    _updateAsync(permission)
        .then((result) => controller.add(result))
        .then((_) => getLocationPermission());

    return controller.stream;
  }

  Future<Result<PermissionModel, Exception>> _updateAsync(
      PermissionModel permission) async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.setBool(
          'permission_location_requested', permission.hasRequested);
      return Result.success(permission);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Stream<Result<void, Exception>> deleteLocationPermission() {
    StreamController<Result<void, Exception>> controller =
        StreamController.broadcast();

    _deleteAsync()
        .then((result) => controller.add(result))
        .then((_) => getLocationPermission());

    return controller.stream;
  }

  Future<Result<void, Exception>> _deleteAsync() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.remove('permission_location_requested');
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
