class DeveloperSettingsModel {
  final bool isDeveloperModeEnabled;

  // Features
  final bool isFetchingWithoutLocationEnabled;
  final bool isPercentagePriceRangesEnabled;
  final DeveloperSettingsMapProvider mapProvider;

  DeveloperSettingsModel(
      this.isDeveloperModeEnabled,
      this.isFetchingWithoutLocationEnabled,
      this.isPercentagePriceRangesEnabled,
      this.mapProvider);
}

enum DeveloperSettingsMapProvider { system, google, mapLibre, apple }
