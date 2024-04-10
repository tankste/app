import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';
import 'package:settings/repository/log_repository.dart';

class FeatureFilter extends LogFilter {
  final LogRepository _logRepository =
      SettingsModuleFactory.createLogRepository();

  // Feels wrong, but the log settings are loading delayed,
  //  and there are missed logs from startup, when disabled by default
  bool _isLoggingEnabled = true;

  FeatureFilter() {
    _logRepository.get().listen((result) {
      _isLoggingEnabled = result.tryGetSuccess() ?? false;
    });
  }

  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode || _isLoggingEnabled;
  }
}
