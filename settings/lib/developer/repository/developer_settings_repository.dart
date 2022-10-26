import 'package:core/app/model/app_info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings/developer/model/developer_settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DeveloperSettingsRepository {
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

  @override
  Future<DeveloperSettingsModel> update(
      DeveloperSettingsModel developerSettings) async {
    return _getPreferences().then((preferences) {
      return Future.wait([
        preferences.setBool(
            keyDeveloperMode, developerSettings.isDeveloperModeEnabled),
        preferences.setBool(keyFetchingWithoutLocation,
            developerSettings.isFetchingWithoutLocationEnabled),
        preferences.setBool(keyPercentagePriceRanges,
            developerSettings.isPercentagePriceRangesEnabled),
        preferences.setString(
            keyDeveloperMode, _getProviderValueKey(developerSettings.mapProvider)),
      ]);
    }).then((_) => developerSettings);
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
