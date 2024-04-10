import 'dart:async';

import 'package:core/device/model/device_model.dart';
import 'package:core/log/log.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class DeviceRepository {
  Stream<Result<DeviceModel, Exception>> get();

  Stream<Result<DeviceModel, Exception>> update(DeviceModel device);
}

class LocalDeviceRepository extends DeviceRepository {
  static final LocalDeviceRepository _instance =
      LocalDeviceRepository._internal();

  factory LocalDeviceRepository() {
    return _instance;
  }

  LocalDeviceRepository._internal();

  @override
  Stream<Result<DeviceModel, Exception>> get() {
    StreamController<Result<DeviceModel, Exception>> streamController =
        StreamController.broadcast();

    _getAsync().then((result) => streamController.add(result));

    return streamController.stream;
  }

  Future<Result<DeviceModel, Exception>> _getAsync() async {
    try {
      SharedPreferences preferences = await _getPreferences();
      String? id = preferences.getString("device_id");
      if (id == null) {
        id = const Uuid().v4();
        await preferences.setString("device_id", id);
      }

      return Result.success(DeviceModel(id: id));
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Stream<Result<DeviceModel, Exception>> update(DeviceModel device) {
    StreamController<Result<DeviceModel, Exception>> streamController =
        StreamController.broadcast();

    _updateAsync(device).then((result) => streamController.add(result));

    return streamController.stream;
  }

  Future<Result<DeviceModel, Exception>> _updateAsync(DeviceModel device) async {
    try {
      SharedPreferences preferences = await _getPreferences();
      await preferences.setString("device_id", device.id);

      return Result.success(device);
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
