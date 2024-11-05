import 'dart:async';

import 'package:core/log/log.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LogRepository {
  Stream<Result<bool, Exception>> get();

  Stream<Result<bool, Exception>> update(bool enabled);
}

class LocalLogRepository extends LogRepository {
  static final LocalLogRepository _singleton = LocalLogRepository._internal();

  factory LocalLogRepository() {
    return _singleton;
  }

  LocalLogRepository._internal();

  final StreamController<Result<bool, Exception>> _logEnabledStreamController =
      StreamController<Result<bool, Exception>>.broadcast();

  @override
  Stream<Result<bool, Exception>> get() {
    _getAsync().then((result) => _logEnabledStreamController.add(result));
    return _logEnabledStreamController.stream;
  }

  Future<Result<bool, Exception>> _getAsync() async {
    try {
      SharedPreferences preferences = await _getPreferences();
      bool enabled = preferences.getBool("log_enabled") ?? false;
      return Result.success(enabled);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Stream<Result<bool, Exception>> update(bool enabled) {
    StreamController<Result<bool, Exception>> controller =
        StreamController.broadcast();

    _updateAsync(enabled)
        .then((result) => controller.add(result))
        .then((_) => get());

    return controller.stream;
  }

  Future<Result<bool, Exception>> _updateAsync(bool enabled) async {
    try {
      SharedPreferences preferences = await _getPreferences();
      await preferences.setBool("log_enabled", enabled);
      return Result.success(enabled);
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
