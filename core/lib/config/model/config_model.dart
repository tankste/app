class ConfigModel {
  final bool useMapLibreMap;
  final String googleMapsKey;
  final String tankerkoenigApiKey;
  final String mapLibreStyleUrlLight;
  final String mapLibreStyleUrlDark;

  Map<String, dynamic> jsonConfig;

  ConfigModel(
      this.jsonConfig,
      this.useMapLibreMap,
      this.googleMapsKey,
      this.tankerkoenigApiKey,
      this.mapLibreStyleUrlLight,
      this.mapLibreStyleUrlDark);

  Map<String, dynamic> jsonConfigFor(String module) {
    return jsonConfig[module] ?? {};
  }

  factory ConfigModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigModel(
        parsedJson['tankste'] ?? <String, dynamic>{},
        parsedJson['tankste']?['useMapLibreMap'] ?? true,
        parsedJson['google']?['mapsKey'] ?? "",
        parsedJson['tankerKoenig']?['apiKey'] ?? "",
        parsedJson['mapLibre']?['styleUrlLight'] ?? "",
        parsedJson['mapLibre']?['styleUrlDark'] ?? "");
  }
}
