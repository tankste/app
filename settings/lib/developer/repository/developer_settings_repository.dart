import 'dart:async';

import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DeveloperSettingsRepository {
  Stream<DeveloperSettingsModel> get();

  Future<DeveloperSettingsModel> update(
      DeveloperSettingsModel developerSettings);
}

class LocalDeveloperSettingsRepository extends DeveloperSettingsRepository {
  final String keyDeveloperMode = "developer_enabled";
  final String keyFetchingWithoutLocation =
      "developer_feature_fetching_without_location";
  final String keyPercentagePriceRanges =
      "developer_feature_percentage_price_ranges";
  final String keyMapProvider = "developer_feature_map_provider";

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
            preferences.setBool(keyFetchingWithoutLocation,
                developerSettings.isFetchingWithoutLocationEnabled),
            preferences.setBool(keyPercentagePriceRanges,
                developerSettings.isPercentagePriceRangesEnabled),
            preferences.setString(keyMapProvider,
                _getProviderValueKey(developerSettings.mapProvider)),
          ]);
        })
        .then((_) => _fetchDeveloperSettings())
        .then((_) => developerSettings);
  }

  void _fetchDeveloperSettings() {
    _getPreferences().then((preferences) {
      return DeveloperSettingsModel(
        preferences.getBool(keyDeveloperMode) ?? false,
        preferences.getBool(keyFetchingWithoutLocation) ?? false,
        preferences.getBool(keyPercentagePriceRanges) ?? false,
        _getProviderFromString(preferences.getString(keyMapProvider) ?? ""),
      );
    }).then((developerSettings) {
      _developerSettingsStreamController.add(developerSettings);
    });
  }

  String _getProviderValueKey(DeveloperSettingsMapProvider provider) {
    switch (provider) {
      case DeveloperSettingsMapProvider.system:
        return "system";
      case DeveloperSettingsMapProvider.google:
        return "google";
      case DeveloperSettingsMapProvider.openStreet:
        return "openStreet";
      case DeveloperSettingsMapProvider.apple:
        return "apple";
    }
  }

  DeveloperSettingsMapProvider _getProviderFromString(String provider) {
    if (provider == "google") {
      return DeveloperSettingsMapProvider.google;
    } else if (provider == "openStreet") {
      return DeveloperSettingsMapProvider.openStreet;
    } else if (provider == "apple") {
      return DeveloperSettingsMapProvider.apple;
    } else {
      return DeveloperSettingsMapProvider.system;
    }
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }
}
