import 'dart:async';

import 'package:collection/collection.dart';
import 'package:settings/model/developer_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DeveloperSettingsRepository {
  Stream<DeveloperSettingsModel> get();

  Future<DeveloperSettingsModel> update(
      DeveloperSettingsModel developerSettings);
}

class LocalDeveloperSettingsRepository extends DeveloperSettingsRepository {
  final String keyDeveloperMode = "developer_enabled";
  final String keyFeatures = "enabled_features";

  static final LocalDeveloperSettingsRepository _singleton =
      LocalDeveloperSettingsRepository._internal();

  factory LocalDeveloperSettingsRepository() {
    return _singleton;
  }

  LocalDeveloperSettingsRepository._internal();

  final StreamController<DeveloperSettingsModel>
      _developerSettingsStreamController =
      StreamController<DeveloperSettingsModel>.broadcast();

  @override
  Stream<DeveloperSettingsModel> get() {
    _fetchDeveloperSettings();
    return _developerSettingsStreamController.stream;
  }

  @override
  Future<DeveloperSettingsModel> update(
      DeveloperSettingsModel developerSettings) async {
    return _getPreferences()
        .then((preferences) {
          return Future.wait([
            preferences.setBool(
                keyDeveloperMode, developerSettings.isDeveloperModeEnabled),
            preferences.setStringList(keyFeatures,
                developerSettings.enabledFeatures.map((f) => f.name).toList())
          ]);
        })
        .then((_) => _fetchDeveloperSettings())
        .then((_) => developerSettings);
  }

  void _fetchDeveloperSettings() {
    _getPreferences().then((preferences) {
      return DeveloperSettingsModel(
          isDeveloperModeEnabled:
              preferences.getBool(keyDeveloperMode) ?? false,
          enabledFeatures: (preferences.getStringList("enabled_features") ?? [])
              .map((s) => Feature.values.firstWhereOrNull((f) => f.name == s))
              .whereNotNull()
              .toList());
    }).then((developerSettings) {
      _developerSettingsStreamController.add(developerSettings);
    });
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
