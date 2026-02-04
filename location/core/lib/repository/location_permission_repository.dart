import 'dart:async';

import 'package:core/log/log.dart';
import 'package:location_core/model/permission_model.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocationPermissionRepository {
  Future<Result<PermissionModel, Exception>> getLocationPermission();

  Future<Result<PermissionModel, Exception>> updateLocationPermission(
      PermissionModel permission);

  Future<Result<void, Exception>> deleteLocationPermission();
}

class LocalLocationPermissionRepository extends LocationPermissionRepository {
  static final LocalLocationPermissionRepository _instance =
      LocalLocationPermissionRepository._internal();

  factory LocalLocationPermissionRepository() {
    return _instance;
  }

  LocalLocationPermissionRepository._internal();

  @override
  Future<Result<PermissionModel, Exception>> getLocationPermission() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      PermissionModel permission = PermissionModel(
          hasRequested:
              preferences.getBool('permission_location_requested') ?? false);
      return Result.success(permission);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<PermissionModel, Exception>> updateLocationPermission(
      PermissionModel permission) async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.setBool(
          'permission_location_requested', permission.hasRequested);
      return Result.success(permission);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void, Exception>> deleteLocationPermission() async {
    try {
      final SharedPreferences preferences = await _getPreferences();
      await preferences.remove('permission_location_requested');
      return const Result.success(null);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
