class ConfigModel {
  final bool useMapLibreMap;
  final String googleMapsKey;
  final String tankerkoenigApiKey;
  final String mapLibreStyleUrlLight;
  final String mapLibreStyleUrlDark;

  ConfigModel(
      this.useMapLibreMap,
      this.googleMapsKey,
      this.tankerkoenigApiKey,
      this.mapLibreStyleUrlLight,
      this.mapLibreStyleUrlDark);

  factory ConfigModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigModel(
        parsedJson['tankste']['useMapLibreMap'] ?? true,
        parsedJson['google']['mapsKey'] ?? "",
        parsedJson['tankerKoenig']['apiKey'] ?? "",
        parsedJson['mapLibre']['styleUrlLight'] ?? "",
        parsedJson['mapLibre']['styleUrlDark'] ?? "");
  }
}
