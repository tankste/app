import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:settings/model/map_destination_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

abstract class MapDestinationRepository {
  Future<List<MapDestinationModel>> listAvailable();

  Future<MapDestinationModel> get();

  Future<MapDestinationModel> update(MapDestinationModel mapDestination);
}

class LocalMapDestinationRepository extends MapDestinationRepository {
  static final LocalMapDestinationRepository _singleton =
      LocalMapDestinationRepository._internal();

  factory LocalMapDestinationRepository() {
    return _singleton;
  }

  LocalMapDestinationRepository._internal();

  final MapDestinationModel systemDestination =
      MapDestinationModel(tr('settings.app.navigation_map.system'), MapDestinationDestination.system);

  @override
  Future<List<MapDestinationModel>> listAvailable() {
    return MapLauncher.installedMaps.then((value) {
      return [systemDestination] +
          value.map((m) {
            return MapDestinationModel(
                m.mapName, _typeToDestination(m.mapType));
          }).toList();
    });
  }

  @override
  Future<MapDestinationModel> get() {
    return _getPreferences()
        .then((preferences) {
          if (!preferences.containsKey("map_destination")) {
            return null;
          }

          return preferences.getString("map_destination");
        })
        .then((key) => _keyToDestination(key))
        .then((destination) => MapLauncher.installedMaps.then((maps) => maps
            .where((m) => m.mapType == destinationToType(destination))
            .firstOrNull))
        .then((map) {
          if (map == null) {
            return systemDestination;
          }

          return MapDestinationModel(
              map.mapName, _typeToDestination(map.mapType));
        });
  }

  @override
  Future<MapDestinationModel> update(MapDestinationModel mapDestination) {
    return _getPreferences().then((preferences) {
      return preferences.setString(
          "map_destination", _destinationToKey(mapDestination.destination));
    }).then((value) => get());
  }

  // TODO: while `getInstance()` is asynchronous, we can't inject this without trouble.
  //  Find solution
  Future<SharedPreferences> _getPreferences() {
    return SharedPreferences.getInstance();
  }

  String _destinationToKey(MapDestinationDestination destination) {
    switch (destination) {
      case MapDestinationDestination.appleMaps:
        return "appleMaps";
      case MapDestinationDestination.googleMaps:
        return "googleMaps";
      case MapDestinationDestination.googleMapsGo:
        return "googleMapsGo";
      case MapDestinationDestination.amap:
        return "amap";
      case MapDestinationDestination.baiduMaps:
        return "baiduMaps";
      case MapDestinationDestination.waze:
        return "waze";
      case MapDestinationDestination.yandexMaps:
        return "yandexMaps";
      case MapDestinationDestination.yandexNavigator:
        return "yandexNavigator";
      case MapDestinationDestination.citymapper:
        return "citymapper";
      case MapDestinationDestination.mapsMe:
        return "mapsMe";
      case MapDestinationDestination.osmAnd:
        return "osmAnd";
      case MapDestinationDestination.osmAndPlus:
        return "osmAndPlus";
      case MapDestinationDestination.twoGis:
        return "twoGis";
      case MapDestinationDestination.tencent:
        return "tencent";
      case MapDestinationDestination.hereWeGo:
        return "hereWeGo";
      case MapDestinationDestination.petalMaps:
        return "petalMaps";
      case MapDestinationDestination.tomTomGo:
        return "tomTomGo";
      default:
        return "system";
    }
  }

  MapDestinationDestination _keyToDestination(String? key) {
    switch (key) {
      case "appleMaps":
        return MapDestinationDestination.appleMaps;
      case "googleMaps":
        return MapDestinationDestination.googleMaps;
      case "googleMapsGo":
        return MapDestinationDestination.googleMapsGo;
      case "amap":
        return MapDestinationDestination.amap;
      case "baiduMaps":
        return MapDestinationDestination.baiduMaps;
      case "waze":
        return MapDestinationDestination.waze;
      case "yandexMaps":
        return MapDestinationDestination.yandexMaps;
      case "yandexNavigator":
        return MapDestinationDestination.yandexNavigator;
      case "citymapper":
        return MapDestinationDestination.citymapper;
      case "mapsMe":
        return MapDestinationDestination.mapsMe;
      case "osmAnd":
        return MapDestinationDestination.osmAnd;
      case "osmAndPlus":
        return MapDestinationDestination.osmAndPlus;
      case "twoGis":
        return MapDestinationDestination.twoGis;
      case "tencent":
        return MapDestinationDestination.tencent;
      case "hereWeGo":
        return MapDestinationDestination.hereWeGo;
      case "petalMaps":
        return MapDestinationDestination.petalMaps;
      case "tomTomGo":
        return MapDestinationDestination.tomTomGo;
      default:
        return MapDestinationDestination.system;
    }
  }

  MapDestinationDestination _typeToDestination(MapType mapType) {
    switch (mapType) {
      case MapType.apple:
        return MapDestinationDestination.appleMaps;
      case MapType.google:
        return MapDestinationDestination.googleMaps;
      case MapType.googleGo:
        return MapDestinationDestination.googleMapsGo;
      case MapType.amap:
        return MapDestinationDestination.amap;
      case MapType.baidu:
        return MapDestinationDestination.baiduMaps;
      case MapType.waze:
        return MapDestinationDestination.waze;
      case MapType.yandexMaps:
        return MapDestinationDestination.yandexMaps;
      case MapType.yandexNavi:
        return MapDestinationDestination.yandexNavigator;
      case MapType.citymapper:
        return MapDestinationDestination.citymapper;
      case MapType.mapswithme:
        return MapDestinationDestination.mapsMe;
      case MapType.osmand:
        return MapDestinationDestination.osmAnd;
      case MapType.osmandplus:
        return MapDestinationDestination.osmAndPlus;
      case MapType.doubleGis:
        return MapDestinationDestination.twoGis;
      case MapType.tencent:
        return MapDestinationDestination.tencent;
      case MapType.here:
        return MapDestinationDestination.hereWeGo;
      case MapType.petal:
        return MapDestinationDestination.petalMaps;
      case MapType.tomtomgo:
        return MapDestinationDestination.tomTomGo;
      default:
        return MapDestinationDestination.system;
    }
  }

  MapType? destinationToType(MapDestinationDestination destination) {
    switch (destination) {
      case MapDestinationDestination.appleMaps:
        return MapType.apple;
      case MapDestinationDestination.googleMaps:
        return MapType.google;
      case MapDestinationDestination.googleMapsGo:
        return MapType.googleGo;
      case MapDestinationDestination.amap:
        return MapType.amap;
      case MapDestinationDestination.baiduMaps:
        return MapType.baidu;
      case MapDestinationDestination.waze:
        return MapType.waze;
      case MapDestinationDestination.yandexMaps:
        return MapType.yandexMaps;
      case MapDestinationDestination.yandexNavigator:
        return MapType.yandexNavi;
      case MapDestinationDestination.citymapper:
        return MapType.citymapper;
      case MapDestinationDestination.mapsMe:
        return MapType.mapswithme;
      case MapDestinationDestination.osmAnd:
        return MapType.osmand;
      case MapDestinationDestination.osmAndPlus:
        return MapType.osmandplus;
      case MapDestinationDestination.twoGis:
        return MapType.doubleGis;
      case MapDestinationDestination.tencent:
        return MapType.tencent;
      case MapDestinationDestination.hereWeGo:
        return MapType.here;
      case MapDestinationDestination.petalMaps:
        return MapType.petal;
      case MapDestinationDestination.tomTomGo:
        return MapType.tomtomgo;
      default:
        return null;
    }
  }
}
