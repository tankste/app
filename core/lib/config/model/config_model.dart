class ConfigModel {
  final bool useOpenStreetMap;
  final String googleMapsKey;
  final String tankerkoenigApiKey;

  ConfigModel(this.useOpenStreetMap, this.googleMapsKey, this.tankerkoenigApiKey);

  factory ConfigModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigModel(
        parsedJson['tankste']['useOpenStreetMap'] ?? true,
        parsedJson['google']['mapsKey'] ?? "",
        parsedJson['tankerKoenig']['apiKey'] ?? ""
    );
  }
}
