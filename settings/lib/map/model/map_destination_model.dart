
class MapDestinationModel {
  String label;
  MapDestinationDestination destination;

  MapDestinationModel(this.label, this.destination);
}

enum MapDestinationDestination {
  system,
  googleMaps,
  googleMapsGo,
  appleMaps,
  baiduMaps,
  amap,
  waze,
  yandexMaps,
  yandexNavigator,
  citymapper,
  mapsMe,
  osmAnd,
  osmAndPlus,
  twoGis,
  tencent,
  hereWeGo,
  petalMaps,
  tomTomGo,
}
