import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:settings/di/settings_module_factory.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:settings/repository/developer_settings_repository.dart';

class FeatureFilter extends LogFilter {
  final DeveloperSettingsRepository _developerSettingsRepository =
      SettingsModuleFactory.createDeveloperSettingsRepository();

  // Feels wrong, but the log settings are loading delayed,
  //  and there are missed logs from startup, when disabled by default
  bool _isLoggingEnabled = true;

  FeatureFilter() {
    _developerSettingsRepository.get().listen((developerSettings) {
      _isLoggingEnabled = developerSettings.isFeatureEnabled(Feature.logging);
    });
  }

  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode || _isLoggingEnabled;
  }
}
