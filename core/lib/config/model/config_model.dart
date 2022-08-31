class ConfigModel {
  final String googleMapsKey;
  final String tankerkoenigApiKey;

  ConfigModel(this.googleMapsKey, this.tankerkoenigApiKey);

  factory ConfigModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigModel(
        parsedJson['google']['mapsKey'] ?? "",
        parsedJson['tankerKoenig']['apiKey'] ?? ""
    );
  }
}
