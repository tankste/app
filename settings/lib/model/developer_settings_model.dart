class DeveloperSettingsModel {
  final bool isDeveloperModeEnabled;
  final List<Feature> enabledFeatures;

  // Features

  DeveloperSettingsModel({
    required this.isDeveloperModeEnabled,
    required this.enabledFeatures,
  });

  bool isFeatureEnabled(Feature feature) {
    return enabledFeatures.contains(feature);
  }

  DeveloperSettingsModel copyWith({
    bool? isDeveloperModeEnabled,
    List<Feature>? enabledFeatures,
  }) {
    return DeveloperSettingsModel(
      isDeveloperModeEnabled:
          isDeveloperModeEnabled ?? this.isDeveloperModeEnabled,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
    );
  }

  @override
  String toString() {
    return 'DeveloperSettingsModel{isDeveloperModeEnabled: $isDeveloperModeEnabled, enabledFeatures: $enabledFeatures}';
  }
}

enum Feature { stationMetaInfo }
