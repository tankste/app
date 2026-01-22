class MapProviderModel {
  String label;
  MapProvider provider;

  MapProviderModel(this.label, this.provider);
}

enum MapProvider {
  system,
  googleMaps,
  appleMaps,
  mapLibre,
}
