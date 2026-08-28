class ConfigModel {
  final bool useMapLibreMap;
  final String googleMapsKey;
  final String routeApiUrl;
  final String tankerkoenigApiKey;
  final String mapLibreStyleUrlLight;
  final String mapLibreStyleUrlDark;

  Map<String, dynamic> jsonConfig;

  ConfigModel({
    required this.jsonConfig,
    required this.useMapLibreMap,
    required this.routeApiUrl,
    required this.googleMapsKey,
    required this.tankerkoenigApiKey,
    required this.mapLibreStyleUrlLight,
    required this.mapLibreStyleUrlDark,
  });

  Map<String, dynamic> jsonConfigFor(String module) {
    return jsonConfig[module] ?? {};
  }

  factory ConfigModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConfigModel(
      jsonConfig: parsedJson['tankste'] ?? <String, dynamic>{},
      useMapLibreMap: parsedJson['tankste']?['useMapLibreMap'] ?? true,
      mapLibreStyleUrlLight: parsedJson['mapLibre']?['styleUrlLight'] ?? "",
      mapLibreStyleUrlDark: parsedJson['mapLibre']?['styleUrlDark'] ?? "",
      routeApiUrl: parsedJson['tankste']?['navigation']?['routeApiUrl'] ?? "",
      googleMapsKey: parsedJson['google']?['mapsKey'] ?? "",
      tankerkoenigApiKey: parsedJson['tankerKoenig']?['apiKey'] ?? "",
    );
  }
}
